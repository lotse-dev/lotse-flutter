import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'app_update.dart';
import 'device_info.dart';
import 'install_referrer.dart';
import 'lotse_feature_board.dart';
import 'lotse_feature_board_page.dart';
import 'lotse_feedback.dart';
import 'lotse_feedback_opener.dart';
import 'lotse_feedback_sheet.dart';
import 'lotse_feedback_texts.dart';
import 'lotse_identity.dart';
import 'lotse_identity_boundary.dart';
import 'lotse_in_app.dart';
import 'lotse_survey.dart';
import 'lotse_my_feedback.dart';
import 'lotse_my_feedback_page.dart';
import 'lotse_server_url.dart';
import 'lotse_support_chat.dart';
import 'lotse_support_chat_page.dart';
import 'public_key_provider.dart';
import 'lotse_launch_links.dart';
import 'lotse_link.dart';
import 'lotse_push.dart';
import 'lotse_screens.dart';
import 'lotse_taps.dart';
import 'lotse_backgrounds.dart';
import 'lotse_event_queue.dart';
import 'lotse_replay_buffer.dart';
import 'lotse_replay_recorder.dart';
import 'lotse_replay_upload.dart';
import 'push_channel_stub.dart' if (dart.library.io) 'push_channel.dart';
import 'push_tokens.dart';
import 'lotse_log.dart';

/// Entry point of the SDK. Call [Lotse.init] once at app start.
class Lotse {
  Lotse._(
    this._client,
    this._identity,
    this._sessionId, {
    LotseIdentifyCall? identify,
    LotseTrackCall? track,
    LotseEventStore? events,
  }) : _identifyCall = identify,
       _trackCall = track,
       _eventStore = events ?? MemoryLotseEventStore() {
    // The pages of the SDK close when the identity ends, and the in-app
    // messages of the old identity go with it.
    _identity.generation.addListener(() {
      lotseIdentityEpoch.value++;
      _inApp.clear();
      _surveys.clear();
    });
  }

  /// An SDK over [identity] whose [Lotse.identify] calls [identify] and
  /// whose [Lotse.track] sends through [track] into [events] instead of the
  /// server. Nothing else is connected; for tests of the facade.
  @visibleForTesting
  Lotse.forTesting({
    required LotseIdentityManager identity,
    LotseIdentifyCall? identify,
    LotseTrackCall? track,
    LotseEventStore? events,
  }) : this._(
         generated.Client('http://localhost:0/'),
         identity,
         const Uuid().v4(),
         identify: identify,
         track: track,
         events: events,
       );

  final generated.Client _client;
  final LotseIdentityManager _identity;
  final LotseIdentifyCall? _identifyCall;
  final LotseTrackCall? _trackCall;
  final LotseEventStore _eventStore;

  /// Whether the server knows the current install in this run. Until then
  /// sending events registers it first; see [_sendEvents].
  var _connected = false;

  late final _events = LotseEventQueue(
    store: _eventStore,
    send: _sendEvents,
    installId: () {
      try {
        return _identity.current.installId;
      } on LotseIdentityUnavailable {
        return null;
      }
    },
    isRefused: (error) => error is generated.LotseInvalidInputException,
    isOverQuota: (error) => error is generated.LotseQuotaExceededException,
  );

  /// Ties the events of one app start together. A new one after [reset], so
  /// the events of two users are not one session.
  String _sessionId;
  final _deferredLink = Completer<LotseLink?>();
  final _initialPush = Completer<LotsePush?>();
  final _pushOpened = StreamController<LotsePush>.broadcast();

  // Every call goes through the identity manager. It hands in the install id
  // and the credential of the identity the call started under, and drops the
  // answer when [reset] ended that identity in the meantime. The install id
  // the classes below pass along is therefore not used.
  late final LotseConversations _conversations = ServerLotseConversations(
    installId: '',
    listMyFeedback: (_) => _identity.runPrivate(_client.sdk.listMyFeedback),
    getMyFeedback: (_, feedbackId) => _identity.runPrivate(
      (installId, credential) =>
          _client.sdk.getMyFeedback(installId, credential, feedbackId),
    ),
    replyToFeedback: (_, feedbackId, body) => _identity.runPrivate(
      (installId, credential) =>
          _client.sdk.replyToFeedback(installId, credential, feedbackId, body),
    ),
    markFeedbackRead: (_, feedbackId) => _identity.runPrivate(
      (installId, credential) =>
          _client.sdk.markFeedbackRead(installId, credential, feedbackId),
    ),
    // A Serverpod streaming method: the client opens a WebSocket and sends
    // the public key with the open command, like the header of a call.
    watchMyFeedback: (_, feedbackId) => _identity.watchPrivate(
      (installId, credential) => lotseCancelAfterFirst(
        _client.sdk.watchMyFeedback(installId, credential, feedbackId),
      ),
    ),
  );
  late final _unreadFeedback = LotseUnreadFeedback(_conversations);
  late final _inApp = LotseInAppInbox(
    fetch: () async => [
      for (final message in await _identity.runPrivate(
        _client.sdk.inAppMessages,
      ))
        lotseInAppMessageFrom(message),
    ],
    track: (name, props) => track(name, props: props),
  );
  late final _surveys = LotseSurveyDesk(
    fetch: () async {
      final survey = await _identity.runPrivate(_client.sdk.pendingSurvey);
      return survey == null ? null : lotseSurveyFrom(survey);
    },
    answer: (surveyId, {score, choice, comment}) => _identity.runPrivate(
      (installId, credential) => _client.sdk.answerSurvey(
        installId,
        credential,
        surveyId,
        score: score,
        choice: choice,
        comment: comment,
      ),
    ),
    track: (name, props) => track(name, props: props),
    isBlocked: () => _inApp.current.value != null,
  );
  late final LotseSupportChat _supportChat = _SessionSupportChat(
    () => ServerLotseSupportChat(
      installId: '',
      sessionId: _sessionId,
      getSupportChat: (_) => _identity.runPrivate(_client.sdk.getSupportChat),
      submitFeedback: _submitFeedback,
    ),
  );
  late final _featureBoard = ServerLotseFeatureBoard(
    installId: '',
    listFeatureRequests: (_, {status}) => _identity.run(
      (installId, credential) => _client.sdk.listFeatureRequests(
        installId,
        status: status,
        credential: credential,
      ),
    ),
    voteFeature: (_, id) => _identity.run(
      (installId, credential) =>
          _client.sdk.voteFeature(installId, id, credential: credential),
    ),
    unvoteFeature: (_, id) => _identity.run(
      (installId, credential) =>
          _client.sdk.unvoteFeature(installId, id, credential: credential),
    ),
  );

  Future<int> _submitFeedback(
    String _,
    generated.FeedbackSubmission submission, {
    ByteData? screenshot,
  }) => _identity.run(
    (installId, credential) => _client.sdk.submitFeedback(
      installId,
      submission,
      screenshot: screenshot,
      credential: credential,
    ),
  );

  /// Names this install towards the server. Public, not a secret: what opens
  /// the conversations of the install is a credential the SDK keeps in the
  /// secure storage of the platform and never hands out.
  ///
  /// Stable until [reset], which starts a new install id.
  String get installId => _identity.current.installId;

  static Lotse? _instance;
  static Future<void>? _initialization;

  /// The initialised SDK. Throws if [init] has not been called.
  static Lotse get instance =>
      _instance ?? (throw StateError('Call Lotse.init() before use.'));

  /// Keeps a link that reopens the app while `main` is still starting, and
  /// hands it to the app's router after the first frame.
  ///
  /// Call it right after `WidgetsFlutterBinding.ensureInitialized()`, before
  /// anything is awaited. When Android ended the app's process in the
  /// background, it restores the app first and delivers the link a moment
  /// later; without this call it arrives while no router listens yet, and the
  /// app opens on its first screen instead of the link. Needs no [init] and
  /// does nothing on a second call.
  static void captureLaunchLinks() =>
      LotseLaunchLinks.start(WidgetsBinding.instance);

  /// Connects the SDK to the Lotse server at [serverUrl], registers the device
  /// and reports a `session_start` event.
  ///
  /// [publicKey] identifies the project. Calling this more than once does
  /// nothing. Failures are logged, never thrown into the app.
  ///
  /// [serverUrl] must be an `https` URL of the backend, self-hosted or not,
  /// optionally with a base path: `https://api.example.com/`. It carries the
  /// install credential and private conversations, so plain `http` is only
  /// available during development, with [allowInsecureLocalhost] and only for
  /// the device's own machine or the address an Android emulator reaches its
  /// host under. In a release build even that is refused.
  ///
  /// A URL that breaks these rules is a configuration mistake and is the one
  /// thing this call does throw: [LotseServerUrlError], before any request is
  /// made and without quoting the URL. Pointing the SDK at another server
  /// starts a new install there; nothing of the old identity is sent to it.
  ///
  /// With [heatmaps] a `LotseScope` around the app records taps on the
  /// screens a `LotseScreenObserver` reports and sends them in batches, at
  /// most every 30 seconds and when the app goes to the background. Rage taps
  /// (three or more quick taps on one spot) also become the event `rage_tap`.
  /// Taps are behavioural data like events: ask your users for consent as you
  /// do for analytics. Taps on a `LotseConfidential` region and on dialogs
  /// are not recorded. Off by default.
  ///
  /// A heatmap is drawn over a screenshot of its screen, one per screen, app
  /// version and width class. With heatmaps on, the SDK takes a missing one
  /// once the screen has been still for a second, in the builds
  /// [heatmapBackgrounds] names: by default only outside release builds, so
  /// the developer's own device provides them and no end user's screen
  /// leaves the phone. `LotseConfidential` regions are blacked out.
  ///
  /// With [replay] a `LotseScope` keeps the last seconds of the screen in
  /// memory, masked like screenshots, so a feedback message can come with
  /// what led up to it. Nothing is sent unless the user attaches it. Call
  /// [init] before `runApp`, so the scope sees the option when it starts.
  /// Off by default.
  static Future<void> init({
    required String publicKey,
    required String serverUrl,
    bool allowInsecureLocalhost = false,
    bool heatmaps = false,
    LotseBackgrounds heatmapBackgrounds = LotseBackgrounds.developmentBuilds,
    LotseReplayOptions? replay,
  }) {
    if (_initialization case final running?) return running;
    lotseReplayOptions = replay;
    final target = checkLotseServerUrl(
      serverUrl,
      allowInsecureLocalhost: allowInsecureLocalhost,
      isReleaseBuild: kReleaseMode,
    );
    final initialization = _init(
      publicKey: publicKey,
      serverUrl: target,
      heatmaps: heatmaps,
      heatmapBackgrounds: heatmapBackgrounds,
    );
    // Screens shown while init runs are reported once it is done.
    lotseScreenTracker = (screen) => unawaited(
      initialization.then(
        (_) => _instance?.track(screenViewEventName, props: {'screen': screen}),
      ),
    );
    return _initialization = initialization;
  }

  static Future<void> _init({
    required String publicKey,
    required Uri serverUrl,
    required bool heatmaps,
    required LotseBackgrounds heatmapBackgrounds,
  }) async {
    const uuid = Uuid();
    final client = generated.Client(serverUrl.toString())
      ..connectivityMonitor = FlutterConnectivityMonitor()
      ..authKeyProvider = PublicKeyProvider(publicKey);

    SharedPreferences? preferences;
    try {
      preferences = await SharedPreferences.getInstance();
    } catch (error) {
      lotseLog('could not open the preferences', error);
    }

    final identity = LotseIdentityManager(
      store: PlatformLotseIdentityStore(
        preferences,
        serverOrigin: lotseServerOrigin(serverUrl),
      ),
      server: LotseIdentityServer(
        register: (installId, credential) =>
            _registerDevice(client, installId, credential),
        claim: client.sdk.claimInstallCredential,
        revoke: client.sdk.revokeInstallCredential,
        isCredentialRefused: (error) =>
            error is generated.LotseInstallCredentialException,
        isDeviceUnknown: (error) => error is generated.LotseNotFoundException,
      ),
    );
    await identity.load();

    final lotse = Lotse._(
      client,
      identity,
      uuid.v4(),
      events: PreferencesLotseEventStore(preferences),
    );
    await lotse._events.load();
    _instance = lotse;
    // From here on a tapped reply push can open its conversation, as soon as
    // a LotseScope has brought the navigator.
    lotseFeedbackOpener.handler = lotse._openThreadFromPush;
    // From here on LotseInAppMessages shows what the inbox holds.
    lotseInAppInbox.value = lotse._inApp;
    lotseSurveyDesk.value = lotse._surveys;
    if (heatmaps) lotse._startHeatmaps(heatmapBackgrounds, preferences);
    lotse._startEventQueue();

    try {
      await identity.connect();
      lotse._connected = true;
      if (preferences != null) {
        lotse._deferredLink.complete(
          await resolveDeferredLotseLinkOnce(
            preferences,
            () => identity.run(
              (installId, credential) => client.sdk.resolveDeferredLink(
                installId,
                credential: credential,
              ),
            ),
          ),
        );
      }
      unawaited(lotse._unreadFeedback.refresh());
      await lotse._startPushMessaging();
    } catch (error) {
      lotseLog('could not register the device', error);
    } finally {
      if (!lotse._deferredLink.isCompleted) lotse._deferredLink.complete(null);
      if (!lotse._initialPush.isCompleted) lotse._initialPush.complete(null);
    }
    // Also without a network: the queue keeps the session until the server
    // can be reached, and then sends what earlier runs left as well.
    if (lotse._connected) {
      await lotse.track('session_start');
      unawaited(lotse._checkInAppAndSurvey());
    } else {
      // The connect just failed; trying again right away would only keep
      // init waiting on the network a second time.
      await lotse._enqueue('session_start');
      lotse._events.retryLater();
    }
    if (preferences != null) await lotse._trackAppUpdate(preferences);
  }

  /// Sends the queue when the network comes back, when the app returns to
  /// the front and when it is hidden.
  void _startEventQueue() {
    _client.connectivityMonitor?.addListener((connected) {
      if (connected) unawaited(_events.flush());
    });
    // Lives as long as the SDK, which lives as long as the app.
    AppLifecycleListener(
      onShow: () => unawaited(_events.flush()),
      onHide: () => unawaited(_events.flush()),
    );
  }

  /// Registers or refreshes the device [installId] with its [credential],
  /// null before the first claim. The install referrer goes along once per
  /// app install, not once per identity.
  static Future<void> _registerDevice(
    generated.Client client,
    String installId,
    String? credential,
  ) async {
    SharedPreferences? preferences;
    try {
      preferences = await SharedPreferences.getInstance();
    } catch (_) {
      // Without preferences there is no referrer to report.
    }
    final device = await collectDeviceDetails();
    final referrer = preferences == null
        ? null
        : await readInstallReferrerOnce(preferences);
    await client.sdk.registerDevice(
      generated.DeviceRegistration(
        installId: installId,
        platform: generated.DevicePlatform.fromJson(device.platform),
        osVersion: device.osVersion,
        locale: device.locale,
        appVersion: device.appVersion,
        appBundleId: device.appBundleId,
        installReferrer: referrer,
      ),
      credential: credential,
    );
    // Only a referrer that actually arrived is reported; a failed read is
    // tried again on the next start.
    if (preferences != null && referrer != null) {
      await markInstallReferrerReported(preferences);
    }
  }

  /// Ends the identity of this install and starts a new, empty one. Call it
  /// when the user of the host app logs out or another account takes over,
  /// before the next user sees the app.
  ///
  /// Lotse has no accounts: feedback, the support chat and pushes belong to
  /// an anonymous install. Without this call the next user of the same app
  /// install would go on in the conversations of the previous one.
  ///
  /// What happens, in this order:
  ///
  /// * At once, before the returned future completes: open Lotse pages close,
  ///   their live updates stop, [unreadFeedbackCount] drops to zero, and answers
  ///   of the server that are still on their way are discarded.
  /// * The secret credential of the old identity leaves the device, and the
  ///   push token of the device is deleted.
  /// * The server revokes the old credential and unregisters the old push
  ///   token. Without a network this is made up for on the next app start.
  /// * A new install id is registered with a new credential and a new push
  ///   token. [installId] changes. The new install is anonymous: the user
  ///   from [identify] is not carried over; call [identify] again after the
  ///   next login.
  ///
  /// The conversations of the old identity stay with the team in the console;
  /// from this app install they cannot be reached any more, also not by
  /// logging in again. Failures are logged, never thrown into the app.
  Future<void> reset() async {
    try {
      _sessionId = const Uuid().v4();
      _unreadFeedback.clear();
      // Taps and events of the old identity are not sent under the new one,
      // and do not stay on the device for the next user.
      _taps?.clear();
      final cleared = _events.clear();
      _connected = false;
      final identityReset = _identity.reset(unregisterPush: _deletePushToken);
      await cleared;
      await identityReset;
      await _reportCurrentPushToken();
      unawaited(_unreadFeedback.refresh());
      await track('session_start');
      unawaited(_checkInAppAndSurvey());
    } catch (error) {
      debugPrint('Lotse: could not reset the identity: ${error.runtimeType}');
    }
  }

  /// The link that brought this install, matched on the server at first start.
  ///
  /// Resolved once per install: completes with the link on the first start
  /// that matched, and with `null` on later starts, without a match or on any
  /// failure. Never completes with an error.
  Future<LotseLink?> get deferredLink => _deferredLink.future;

  /// The Lotse push the user tapped to start the app, if any.
  ///
  /// Completes with `null` when the app was started in any other way, when
  /// push is unavailable or on any failure. Never completes with an error.
  ///
  /// A push that announces a reply to feedback is not an app route and never
  /// shows up here or in [pushOpened]: the SDK opens the conversation itself,
  /// see `LotseScope.navigatorKey`.
  Future<LotsePush?> get initialPush => _initialPush.future;

  /// Lotse pushes the user taps while the app is already running.
  Stream<LotsePush> get pushOpened => _pushOpened.stream;

  /// Reports the event [name] for the current session.
  ///
  /// The server refuses events over its limits: a name of 1 to 100 characters,
  /// at most 20 [props], and at most 200 characters per key and value. Props
  /// are for labels and ids, not for payloads. Such an event is not tracked.
  ///
  /// The event is stored on the device first and sent right after. Without a
  /// network it waits, also beyond the end of the app, and goes out once the
  /// server can be reached; after 30 days it is dropped. The returned future
  /// completes after the attempt, also when it failed.
  ///
  /// Failures are logged, never thrown into the app.
  Future<void> track(String name, {Map<String, String>? props}) async {
    try {
      if (await _enqueue(name, props: props)) await _events.flush();
    } catch (error) {
      lotseLog('could not track "$name"', error);
    }
  }

  /// Puts the event [name] into the queue without sending it. False when it
  /// is not tracked at all.
  Future<bool> _enqueue(String name, {Map<String, String>? props}) async {
    final problem = lotseEventProblem(name, props);
    if (problem != null) {
      debugPrint('Lotse: "$name" is not tracked: $problem.');
      return false;
    }
    final String installId;
    try {
      installId = _identity.current.installId;
    } on LotseIdentityUnavailable {
      debugPrint('Lotse: "$name" is not tracked: no identity in this run.');
      return false;
    }
    await _events.add(
      LotseQueuedEvent(
        clientId: const Uuid().v4(),
        installId: installId,
        name: name,
        ts: DateTime.now().toUtc(),
        sessionId: _sessionId,
        props: props == null ? null : Map.unmodifiable(props),
      ),
    );
    return true;
  }

  /// Sends [events] of [installId]. Registers the install first when that
  /// did not happen in this run yet, e.g. after a start without network.
  Future<void> _sendEvents(
    String installId,
    List<LotseQueuedEvent> events,
  ) async {
    if (!_connected) {
      await _identity.connect();
      _connected = true;
    }
    final call = _trackCall ?? _serverTrack;
    try {
      await _identity.run((current, credential) {
        // A reset since the batch was taken: not under the next user.
        if (current != installId) throw const LotseIdentityReplaced();
        return call(current, credential, events);
      });
    } on generated.LotseNotFoundException {
      // The team deleted the device in the console: register it anew.
      _connected = false;
      rethrow;
    } on generated.LotseInstallCredentialException {
      // The credential was revoked; connect starts a new install.
      _connected = false;
      rethrow;
    }
  }

  Future<void> _serverTrack(
    String installId,
    String? credential,
    List<LotseQueuedEvent> events,
  ) => _client.sdk.track(installId, [
    for (final event in events)
      generated.TrackedEvent(
        name: event.name,
        ts: event.ts,
        sessionId: event.sessionId,
        props: event.props,
        clientId: event.clientId,
      ),
  ], credential: credential);

  LotseTapBuffer? _taps;
  var _takesBackgrounds = false;

  /// Points `LotseScope` at a tap buffer that sends to the server, and sends
  /// what is buffered whenever the app is hidden. Lets the scope take the
  /// backgrounds the server asks for when [backgrounds] allows it here.
  void _startHeatmaps(
    LotseBackgrounds backgrounds,
    SharedPreferences? preferences,
  ) {
    if (lotseBackgroundsEnabled(backgrounds, isReleaseBuild: kReleaseMode)) {
      _takesBackgrounds = true;
      lotseBackgroundUploader = _sendBackground;
    }
    final buffer = LotseTapBuffer(
      _sendTaps,
      store: PreferencesLotseTapStore(preferences),
      installId: () => _identity.current.installId,
    );
    _taps = buffer;
    lotseTapSink = buffer.add;
    unawaited(buffer.restore());
    // Lives as long as the SDK, which lives as long as the app. Stored before
    // sending: without a network the send may outlast the app.
    AppLifecycleListener(
      onHide: () => unawaited(buffer.persist().then((_) => buffer.flush())),
    );
  }

  Future<void> _sendTaps(List<LotseTap> taps) async {
    try {
      final missing = await _identity.run(
        (installId, credential) => _client.sdk.submitTaps(installId, [
          for (final tap in taps)
            generated.TrackedTap(
              // The scope hands heatmaps only taps on a named screen.
              screen: tap.screen!,
              ts: tap.ts,
              x: tap.x,
              y: tap.y,
              scrollY: tap.scrollY,
              viewportWidth: tap.viewportWidth,
              viewportHeight: tap.viewportHeight,
              rage: tap.rage,
            ),
        ], credential: credential),
      );
      if (_takesBackgrounds) {
        wantLotseBackgrounds([
          for (final slot in missing)
            (
              screen: slot.screen,
              widthClass: LotseWidthClass.values.byName(slot.widthClass.name),
            ),
        ]);
      }
    } on generated.LotseInvalidInputException catch (_) {
      // Sending again would be refused again: the batch is dropped.
      debugPrint('Lotse: the server refused a batch of taps.');
    } on generated.LotseQuotaExceededException catch (_) {
      debugPrint('Lotse: the tap budget of this project or device is used up.');
    }
  }

  Future<void> _sendBackground(LotseBackgroundShot shot) => _identity.run(
    (installId, credential) => _client.sdk.submitHeatmapBackground(
      installId,
      shot.screen,
      shot.scrollY,
      shot.width,
      shot.height,
      ByteData.sublistView(shot.image),
      credential: credential,
    ),
  );

  /// Writes [appUpdateEventName] with the old and the new version when the
  /// app runs another version than on its last start.
  Future<void> _trackAppUpdate(SharedPreferences preferences) async {
    try {
      final update = await checkAppUpdate(
        preferences,
        await currentAppVersion(),
      );
      if (update == null) return;
      await track(
        appUpdateEventName,
        props: {'from': update.from, 'to': update.to},
      );
    } catch (error) {
      lotseLog('could not check the app version', error);
    }
  }

  /// Tells Lotse which user of your app this install belongs to, with
  /// optional [traits] such as a plan or a language. Call it after login and
  /// whenever the traits change; a later call merges its traits over the
  /// earlier ones.
  ///
  /// [userId] is the id your app uses for the user. Prefer a pseudonymous id
  /// over an e-mail address: it is stored as is (without leading and
  /// trailing whitespace) and shown in the console. The user is a trait for
  /// analytics and segments; it opens nothing private, and no device gains
  /// access to the feedback or conversations of another device of the same
  /// user.
  ///
  /// Without identity verification Lotse takes [userId] as the app says it,
  /// so anybody with your app can claim any id. With an identity secret in
  /// the project settings, your backend computes [userHash] for the
  /// signed-in user (lowercase hex of HMAC-SHA256 over the id with the
  /// secret as key) and the app passes it here; the server refuses a wrong
  /// hash, and a missing one once the project requires verification. The
  /// secret stays on your backend, never in the app. See "Identity
  /// verification" in the README.
  ///
  /// The server refuses calls over its limits: an id of 1 to 256 characters,
  /// at most 50 traits per user, keys of 1 to 64 and values of at most 1024
  /// characters. After [reset] the new install is anonymous until the app
  /// calls [identify] again.
  ///
  /// Failures are logged, never thrown into the app. The log names the kind
  /// of failure, never the id, a trait or the hash.
  Future<void> identify(
    String userId, {
    Map<String, String>? traits,
    String? userHash,
  }) async {
    try {
      final call = _identifyCall ?? _serverIdentify;
      await _identity.runPrivate(
        (installId, credential) =>
            call(installId, credential, userId, traits, userHash),
      );
    } catch (error) {
      debugPrint('Lotse: could not identify the user: ${error.runtimeType}');
    }
  }

  Future<void> _serverIdentify(
    String installId,
    String credential,
    String userId,
    Map<String, String>? traits,
    String? userHash,
  ) => _client.sdk.identify(
    installId,
    credential,
    userId,
    traits: traits,
    userHash: userHash,
  );

  /// Initialises Firebase messaging, reports the token and starts listening
  /// for push opens.
  ///
  /// Every step is optional: an app without a Firebase configuration, a denied
  /// permission or a failing call leaves the rest of the SDK working. Failures
  /// are logged, never thrown into the app. On the web there is no push, and
  /// the browser is not asked for permission, even if the app has Firebase.
  Future<void> _startPushMessaging() async {
    if (kIsWeb) {
      if (!_initialPush.isCompleted) _initialPush.complete(null);
      return;
    }
    try {
      // The host app may have initialised Firebase itself already.
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();

      // Before the first push can arrive, so it lands in the loud channel.
      await createLotsePushChannel();
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      await _reportCurrentPushToken();
      // A new FCM token on iOS may come with a new APNs token too.
      messaging.onTokenRefresh.listen(
        (_) => unawaited(_reportCurrentPushToken()),
        onError: (Object error) => lotseLog('push token refresh failed', error),
      );

      final initialData = (await messaging.getInitialMessage())?.data;
      final initial = lotsePushFromData(initialData);
      _initialPush.complete(initial);
      if (initial != null) await _trackPushOpen(initial);
      final initialFeedback = lotseFeedbackIdFromData(initialData);
      if (initialFeedback != null) lotseFeedbackOpener.open(initialFeedback);

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        // A reply push opens its conversation and stays inside the SDK.
        final feedbackId = lotseFeedbackIdFromData(message.data);
        if (feedbackId != null) {
          lotseFeedbackOpener.open(feedbackId);
          return;
        }
        final push = lotsePushFromData(message.data);
        if (push == null) return;
        _pushOpened.add(push);
        unawaited(_trackPushOpen(push));
      }, onError: (Object error) => lotseLog('push open stream failed', error));
      // A reply that arrives while the app is in front shows no notification,
      // but the badge should know about it.
      FirebaseMessaging.onMessage.listen((message) {
        if (lotseFeedbackIdFromData(message.data) == null) return;
        unawaited(_unreadFeedback.refresh());
      }, onError: (Object error) => lotseLog('push stream failed', error));
    } catch (error) {
      lotseLog('push messaging is unavailable', error);
    } finally {
      if (!_initialPush.isCompleted) _initialPush.complete(null);
    }
  }

  Future<void> _reportPushToken(LotsePushToken token) async {
    try {
      await _identity.runPrivate(
        (installId, credential) => _client.sdk.registerPushToken(
          installId,
          credential,
          token.token,
          token.provider,
        ),
      );
    } catch (error) {
      // Only the kind: the message could quote the call.
      debugPrint(
        'Lotse: could not report the push token: ${error.runtimeType}',
      );
    }
  }

  /// Deletes the push token of the device, so nothing addressed to the old
  /// identity arrives any more, whether or not the server heard of the reset.
  ///
  /// The APNs token of an iPhone cannot be deleted; it belongs to the app
  /// installation. The server takes it off the old device once the new
  /// identity reports it, and revokes the old device's tokens on reset.
  Future<void> _deletePushToken() async {
    if (kIsWeb || Firebase.apps.isEmpty) return;
    await FirebaseMessaging.instance.deleteToken();
  }

  /// Fetches the push tokens for the current identity and reports them: the
  /// FCM token, on iOS the APNs token as well.
  Future<void> _reportCurrentPushToken() async {
    try {
      if (Firebase.apps.isEmpty) return;
      final messaging = FirebaseMessaging.instance;
      final tokens = await lotsePushTokens(
        fcmToken: messaging.getToken,
        apnsToken: messaging.getAPNSToken,
      );
      for (final token in tokens) {
        await _reportPushToken(token);
      }
    } catch (error) {
      debugPrint('Lotse: push messaging is unavailable: ${error.runtimeType}');
    }
  }

  Future<void> _trackPushOpen(LotsePush push) => track(
    'push_open',
    props: {'campaignId': push.campaignId, 'deliveryId': push.deliveryId},
  );

  /// Resolves the link [slug] of this project to its app route and campaign.
  ///
  /// Returns `null` if the link does not exist or the call fails. Failures are
  /// logged, never thrown into the app. A resolved link is tracked as
  /// `link_open` with its slug: the app opened through it.
  Future<LotseLink?> resolveLink(String slug) => resolveLotseLink(
    _client.sdk.resolveLink,
    slug,
    onOpened: (link) =>
        unawaited(track(linkOpenEvent, props: {'slug': link.slug})),
  );

  /// Asks the server for in-app messages now and shows the newest one in
  /// `LotseInAppMessages`, unless one is shown already. The SDK asks by
  /// itself when the app starts and when it comes back to the front, at most
  /// once a minute; call this when your app knows a better moment, for
  /// example right after a purchase. The server allows a device 60 fetches
  /// an hour.
  ///
  /// Without a message on screen it then asks for a survey of the console
  /// as well; the server sends a device at most one survey a week.
  ///
  /// Failures are logged, never thrown into the app.
  Future<void> checkInAppMessages() => _checkInAppAndSurvey();

  /// The in-app messages, then the survey: it waits while a message is on
  /// screen.
  Future<void> _checkInAppAndSurvey() async {
    await _inApp.check(force: true);
    await _surveys.check(force: true);
  }

  /// Opens the feedback sheet above [context] and completes when the user is
  /// done with it.
  ///
  /// With a `LotseScope` around the app the sheet comes with a screenshot of
  /// the screen it was opened on, taken before the sheet appears; without one
  /// it works the same, just without a screenshot. The sheet uses the theme
  /// found at [context].
  ///
  /// [metadata] is stored with the message, at most 20 entries. [askForEmail]
  /// adds an optional e-mail field. [texts] replaces the built-in English and
  /// German texts, which are picked by the device locale.
  ///
  /// Failures are logged and shown in the sheet, never thrown into the app.
  Future<void> showFeedback(
    BuildContext context, {
    Map<String, String>? metadata,
    bool askForEmail = false,
    LotseFeedbackTexts? texts,
  }) => showLotseFeedbackSheet(
    context,
    metadata: metadata,
    askForEmail: askForEmail,
    texts: texts,
    send: (draft) => sendLotseFeedback(
      _submitFeedback,
      installId: '',
      sessionId: _sessionId,
      draft: draft,
      uploadReplay: _uploadReplay,
    ),
  );

  /// Sends the recording of the last seconds after the message, chunk by
  /// chunk. A chunk that does not arrive ends the upload; the message is
  /// there either way.
  Future<void> _uploadReplay(int feedbackId, List<LotseReplayChunk> chunks) =>
      uploadLotseReplay(
        (id, chunk) => _identity.run(
          (installId, credential) => _client.sdk.submitFeedbackReplayChunk(
            installId,
            id,
            chunk,
            credential: credential,
          ),
        ),
        feedbackId,
        chunks,
      );

  /// How many replies of the team to this device's feedback and support chat
  /// are unread, for a badge on the entry that leads to [showMyFeedback] or
  /// [showSupportChat].
  ///
  /// Refreshed at start, when a push announces a reply and when the user has
  /// read a conversation. Stays at the last known number on any failure.
  ValueListenable<int> get unreadFeedbackCount => _unreadFeedback.count;

  /// Opens the list of the feedback this device has sent above [context] and
  /// completes when the user leaves it.
  ///
  /// Each entry shows where the team stands with it and whether there are
  /// unread replies; a tap opens the conversation, where the user can reply.
  /// An open conversation asks the server for new replies every few seconds
  /// and marks what it shows as read. The pages use the theme found at
  /// [context]. [texts] replaces the built-in English and German texts, which
  /// are picked by the device locale.
  ///
  /// Failures are logged and shown in the pages, never thrown into the app.
  Future<void> showMyFeedback(
    BuildContext context, {
    LotseFeedbackTexts? texts,
  }) => showLotseMyFeedback(
    context,
    conversations: _conversations,
    texts: texts,
    onRead: _refreshUnreadFeedback,
  );

  /// Opens the support chat above [context] and completes when the user
  /// leaves it.
  ///
  /// Shows the running conversation of this device, or a field for a first
  /// question that starts one. A conversation is over once the team marked it
  /// done or closed; the next question starts a new one, and the old one
  /// stays in [showMyFeedback]. The chat is switched on per project in the
  /// console and is off by default: while it is off the page shows a notice
  /// instead of the field, and a conversation that already runs stays open
  /// for replies. Replies of the team count into [unreadFeedbackCount] and
  /// arrive as a push like replies to feedback.
  ///
  /// The page uses the theme found at [context]. [texts] replaces the
  /// built-in English and German texts, which are picked by the device
  /// locale.
  ///
  /// Failures are logged and shown in the page, never thrown into the app.
  Future<void> showSupportChat(
    BuildContext context, {
    LotseFeedbackTexts? texts,
  }) => showLotseSupportChat(
    context,
    chat: _supportChat,
    conversations: _conversations,
    texts: texts,
    onRead: _refreshUnreadFeedback,
  );

  /// Opens the feature board above [context] and completes when the user
  /// leaves it.
  ///
  /// The board shows the ideas the team put up in the console, in the tabs
  /// Ideas, Planned, In progress and Shipped, most votes first. The user
  /// votes for an idea or takes the vote back with one tap; the vote shows at
  /// once and is taken back with a message if the server does not take it.
  /// Pulling a tab down loads the board again. Users cannot hand in ideas
  /// here, [showFeedback] with the category idea is the way for that.
  ///
  /// Votes belong to this install. Each one is also an event on the server,
  /// so "voted for X" can be a segment of a push campaign.
  ///
  /// The page uses the theme found at [context]. [texts] replaces the
  /// built-in English and German texts, which are picked by the device
  /// locale.
  ///
  /// Failures are logged and shown in the page, never thrown into the app.
  Future<void> showFeatureBoard(
    BuildContext context, {
    LotseFeedbackTexts? texts,
  }) => showLotseFeatureBoard(context, board: _featureBoard, texts: texts);

  void _refreshUnreadFeedback() => unawaited(_unreadFeedback.refresh());

  /// Opens the conversation of a tapped reply push. There is no context to
  /// take texts or a locale from, so the device locale decides.
  void _openThreadFromPush(NavigatorState navigator, int feedbackId) {
    _refreshUnreadFeedback();
    unawaited(
      pushLotseFeedbackThread(
        navigator,
        conversations: _conversations,
        feedbackId: feedbackId,
        texts: LotseFeedbackTexts.forLocale(
          WidgetsBinding.instance.platformDispatcher.locale,
        ),
        onRead: _refreshUnreadFeedback,
      ),
    );
  }
}

/// The support chat with the session id of the moment. The session id changes
/// with [Lotse.reset], the page keeps one object.
class _SessionSupportChat implements LotseSupportChat {
  _SessionSupportChat(this._current);

  final LotseSupportChat Function() _current;

  @override
  Future<LotseSupportChatState?> state() => _current().state();

  @override
  Future<(LotseSupportChatResult, int?)> ask(String question) =>
      _current().ask(question);
}

/// The server call behind [Lotse.identify]: install id and credential of the
/// current identity, then the user id, traits and user hash of the app.
typedef LotseIdentifyCall =
    Future<void> Function(
      String installId,
      String credential,
      String userId,
      Map<String, String>? traits,
      String? userHash,
    );

/// The server call behind [Lotse.track]: install id and, once there is one,
/// credential of the current identity, then the events of one batch.
typedef LotseTrackCall =
    Future<void> Function(
      String installId,
      String? credential,
      List<LotseQueuedEvent> events,
    );

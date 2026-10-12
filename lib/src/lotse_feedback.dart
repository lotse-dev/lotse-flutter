import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

import 'lotse_annotation.dart';
import 'lotse_capture.dart';
import 'lotse_replay_buffer.dart';

/// Characters in a feedback message. The server checks the same limit.
const maxFeedbackMessageLength = 4000;

/// Characters in the contact e-mail address. The server checks the same limit.
const maxFeedbackEmailLength = 254;

// The same shape the server accepts; anything stricter would turn away
// addresses the server takes.
final _emailShape = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// What a feedback message is about. The user picks one of
/// [lotseSheetCategories] in the sheet; [question] marks a support chat.
enum LotseFeedbackCategory {
  /// Something is broken.
  bug,

  /// A wish or a suggestion.
  idea,

  /// Something the user likes.
  praise,

  /// Anything else.
  other,

  /// A support chat, opened with `Lotse.instance.showSupportChat`. Never
  /// offered in the feedback sheet.
  question,
}

/// The categories the feedback sheet offers.
const lotseSheetCategories = [
  LotseFeedbackCategory.bug,
  LotseFeedbackCategory.idea,
  LotseFeedbackCategory.praise,
  LotseFeedbackCategory.other,
];

/// Maps the public [category] to the generated one. The generated enum never
/// leaves the SDK.
generated.FeedbackCategory generatedFeedbackCategory(
  LotseFeedbackCategory category,
) => switch (category) {
  LotseFeedbackCategory.bug => generated.FeedbackCategory.bug,
  LotseFeedbackCategory.idea => generated.FeedbackCategory.idea,
  LotseFeedbackCategory.praise => generated.FeedbackCategory.praise,
  LotseFeedbackCategory.other => generated.FeedbackCategory.other,
  LotseFeedbackCategory.question => generated.FeedbackCategory.question,
};

/// One feedback message as the sheet hands it to the sender.
class LotseFeedbackDraft {
  /// Creates a draft.
  const LotseFeedbackDraft({
    required this.category,
    required this.message,
    this.contactEmail,
    this.lastScreen,
    this.metadata,
    this.screenshot,
    this.replay,
  });

  /// What the message is about.
  final LotseFeedbackCategory category;

  /// The trimmed text.
  final String message;

  /// The trimmed e-mail address, `null` if the user gave none.
  final String? contactEmail;

  /// The name of the route the sheet was opened on.
  final String? lastScreen;

  /// What the host app attached.
  final Map<String, String>? metadata;

  /// The screenshot the user kept, as PNG.
  final Uint8List? screenshot;

  /// The recording of the last seconds, when the user attaches it.
  final List<LotseReplayChunk>? replay;
}

/// Sends the replay chunks of the feedback message [feedbackId]. Never
/// throws.
typedef LotseReplayUpload =
    Future<void> Function(int feedbackId, List<LotseReplayChunk> chunks);

/// Chunks of the recording of the last seconds, as they are now.
typedef LotseReplaySource = List<LotseReplayChunk> Function();

/// How an attempt to send a draft ended.
enum LotseFeedbackSendResult {
  /// The server stored the message.
  sent,

  /// A quota of the device or the project is used up. Trying again right away
  /// will not help.
  limitReached,

  /// Anything else: no network, a server error, a rejected input.
  failed,
}

/// Sends a draft. Never throws.
typedef LotseFeedbackSender =
    Future<LotseFeedbackSendResult> Function(LotseFeedbackDraft draft);

/// The generated `submitFeedback`, as a function so the mapping can be tested
/// without a server.
typedef SubmitFeedbackCall =
    Future<int> Function(
      String installId,
      generated.FeedbackSubmission submission, {
      ByteData? screenshot,
    });

/// Maps [draft] to the generated types and sends it through [submit]. A
/// replay goes up afterwards through [uploadReplay], without holding the
/// sheet: the message counts as sent once the server has it, whether or
/// not the recording follows.
///
/// Failures are logged, never thrown into the app. The log names the kind of
/// failure only, never the message or the e-mail address.
Future<LotseFeedbackSendResult> sendLotseFeedback(
  SubmitFeedbackCall submit, {
  required String installId,
  required String sessionId,
  required LotseFeedbackDraft draft,
  LotseReplayUpload? uploadReplay,
}) async {
  try {
    final png = draft.screenshot;
    final feedbackId = await submit(
      installId,
      generated.FeedbackSubmission(
        category: generatedFeedbackCategory(draft.category),
        message: draft.message,
        contactEmail: draft.contactEmail,
        lastScreen: draft.lastScreen,
        metadata: draft.metadata,
        sessionId: sessionId,
      ),
      screenshot: png == null ? null : ByteData.sublistView(png),
    );
    final replay = draft.replay;
    if (uploadReplay != null && replay != null && replay.isNotEmpty) {
      unawaited(uploadReplay(feedbackId, replay));
    }
    return LotseFeedbackSendResult.sent;
  } on generated.LotseQuotaExceededException {
    debugPrint('Lotse: the feedback quota is used up.');
    return LotseFeedbackSendResult.limitReached;
  } catch (error) {
    debugPrint('Lotse: could not send the feedback: ${error.runtimeType}');
    return LotseFeedbackSendResult.failed;
  }
}

/// Where the sheet is in its life.
enum LotseFeedbackStatus {
  /// The user is writing.
  editing,

  /// The draft is on its way.
  sending,

  /// The last attempt failed; everything the user entered is still there.
  failed,

  /// The server has the message.
  sent,
}

/// The state of the feedback sheet: what the user entered, the screenshot,
/// validation and sending. Plain Dart, the sheet only renders it.
class LotseFeedbackController extends ChangeNotifier {
  /// Creates the state of one feedback sheet. Drafts go out through the
  /// sender given first.
  LotseFeedbackController(
    this._send, {
    this.askForEmail = false,
    this.lastScreen,
    this.metadata,
    LotseReplaySource? replay,
    this.replaySeconds = 60,
    bool attachReplay = true,
  }) : _replay = replay,
       replayAvailable = replay != null && replay().isNotEmpty,
       // A named parameter cannot be private, so no initializing formal.
       // ignore: prefer_initializing_formals
       _attachReplay = attachReplay;

  final LotseFeedbackSender _send;
  final LotseReplaySource? _replay;

  /// Whether there is a recording the user can attach. Checked once, when
  /// the sheet opens: the recorder is paused while it is open.
  final bool replayAvailable;

  /// Length of the recording, for the label of the switch.
  final int replaySeconds;

  /// Whether the recording goes with the message. Only meaningful while
  /// [replayAvailable].
  bool get attachReplay => _attachReplay;
  bool _attachReplay;
  set attachReplay(bool value) {
    if (value == _attachReplay || isLocked) return;
    _attachReplay = value;
    notifyListeners();
  }

  /// Whether the sheet shows the e-mail field. Without it no address is sent.
  final bool askForEmail;

  /// The name of the route the screenshot shows: the one the sheet was
  /// opened on, or the one the user went to for a retake.
  String? lastScreen;

  /// What the host app attached.
  final Map<String, String>? metadata;

  bool _disposed = false;

  /// What the message is about.
  LotseFeedbackCategory get category => _category;
  LotseFeedbackCategory _category = LotseFeedbackCategory.bug;
  set category(LotseFeedbackCategory value) {
    if (value == _category || isLocked) return;
    _category = value;
    notifyListeners();
  }

  /// The text as typed.
  String get message => _message;
  String _message = '';
  set message(String value) {
    if (value == _message || isLocked) return;
    _message = value;
    notifyListeners();
  }

  /// The e-mail address as typed.
  String get email => _email;
  String _email = '';
  set email(String value) {
    if (value == _email || isLocked) return;
    _email = value;
    notifyListeners();
  }

  /// The screenshot that will be sent, with the strokes of the user burned
  /// in, `null` without one.
  LotseScreenshot? get screenshot => _screenshot;
  LotseScreenshot? _screenshot;

  /// The screenshot as it was captured, without strokes. The editor starts
  /// from it, so strokes of an earlier session can still be undone.
  LotseScreenshot? get capturedScreenshot => _capturedScreenshot;
  LotseScreenshot? _capturedScreenshot;

  /// The strokes burned into [screenshot].
  List<LotseStroke> get strokes => _strokes;
  List<LotseStroke> _strokes = const [];

  /// Why the last capture produced no screenshot, `null` if it did or if the
  /// user removed the screenshot.
  LotseCaptureFailure? get captureFailure => _captureFailure;
  LotseCaptureFailure? _captureFailure;

  /// Where the sheet is in its life.
  LotseFeedbackStatus get status => _status;
  LotseFeedbackStatus _status = LotseFeedbackStatus.editing;

  /// How the last attempt failed. Only meaningful while [status] is
  /// [LotseFeedbackStatus.failed].
  LotseFeedbackSendResult get lastResult => _lastResult;
  LotseFeedbackSendResult _lastResult = LotseFeedbackSendResult.sent;

  /// `true` while nothing may change: during sending and after success.
  bool get isLocked =>
      _status == LotseFeedbackStatus.sending ||
      _status == LotseFeedbackStatus.sent;

  /// `true` if the message is longer than the server accepts.
  bool get isMessageTooLong =>
      _message.trim().length > maxFeedbackMessageLength;

  /// `true` if the e-mail field holds something that is not an address. An
  /// empty field is fine, the address is optional.
  bool get isEmailInvalid {
    if (!askForEmail) return false;
    final value = _email.trim();
    return value.isNotEmpty &&
        (value.length > maxFeedbackEmailLength || !_emailShape.hasMatch(value));
  }

  /// `true` if the draft can go out now.
  bool get canSend =>
      !isLocked &&
      _message.trim().isNotEmpty &&
      !isMessageTooLong &&
      !isEmailInvalid;

  /// Takes over the outcome of a capture. A failed capture removes the
  /// previous screenshot: it showed a screen the user wanted replaced.
  void applyCapture(LotseCaptureResult result) {
    if (isLocked) return;
    switch (result) {
      case LotseCaptureSuccess(:final screenshot):
        _screenshot = screenshot;
        _captureFailure = null;
      case LotseCaptureFailed(:final failure):
        _screenshot = null;
        _captureFailure = failure;
    }
    // Strokes pointed at the old image.
    _capturedScreenshot = _screenshot;
    _strokes = const [];
    notifyListeners();
  }

  /// Takes over what the editor produced: [strokes] and [merged], the captured
  /// screenshot with them burned in. Without strokes the captured screenshot
  /// is sent as it is.
  void applyAnnotation(List<LotseStroke> strokes, LotseScreenshot merged) {
    if (_disposed || isLocked || _capturedScreenshot == null) return;
    _strokes = List.unmodifiable(strokes);
    _screenshot = strokes.isEmpty ? _capturedScreenshot : merged;
    notifyListeners();
  }

  /// Drops the screenshot. The message goes out without one.
  void removeScreenshot() {
    if (isLocked || (_screenshot == null && _captureFailure == null)) return;
    _screenshot = null;
    _capturedScreenshot = null;
    _strokes = const [];
    _captureFailure = null;
    notifyListeners();
  }

  /// The draft as it would be sent now.
  LotseFeedbackDraft get draft {
    final contactEmail = askForEmail ? _email.trim() : '';
    return LotseFeedbackDraft(
      category: _category,
      message: _message.trim(),
      contactEmail: contactEmail.isEmpty ? null : contactEmail,
      lastScreen: lastScreen,
      metadata: metadata,
      screenshot: _screenshot?.png,
      replay: replayAvailable && _attachReplay ? _replay?.call() : null,
    );
  }

  /// Sends the draft. Does nothing unless [canSend]; also serves as retry
  /// after a failure. Never throws.
  Future<void> send() async {
    if (!canSend) return;
    _status = LotseFeedbackStatus.sending;
    notifyListeners();

    LotseFeedbackSendResult result;
    try {
      result = await _send(draft);
    } catch (error) {
      // A sender must not throw, but the sheet must not get stuck if one does.
      debugPrint('Lotse: the feedback sender threw: ${error.runtimeType}');
      result = LotseFeedbackSendResult.failed;
    }
    if (_disposed) return;
    _lastResult = result;
    _status = result == LotseFeedbackSendResult.sent
        ? LotseFeedbackStatus.sent
        : LotseFeedbackStatus.failed;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

import 'lotse_feedback.dart';
import 'lotse_my_feedback.dart';

/// What the server says about the support chat of this device.
@immutable
class LotseSupportChatState {
  /// Creates a state.
  const LotseSupportChatState({required this.enabled, this.feedbackId});

  /// Whether the project accepts new questions.
  final bool enabled;

  /// The running conversation, `null` if there is none. It stays reachable
  /// while the chat is switched off.
  final int? feedbackId;
}

/// How an attempt to open a support chat with a first question ended.
enum LotseSupportChatResult {
  /// The server stored the question; the conversation exists.
  started,

  /// The project has the chat switched off.
  disabled,

  /// A quota of the device or the project is used up. Trying again right away
  /// will not help.
  limitReached,

  /// Anything else: no network, a server error, a rejected input.
  failed,
}

/// The support chat of this device. No method throws.
abstract interface class LotseSupportChat {
  /// Whether the chat is on and which conversation is running, `null` if the
  /// call failed.
  Future<LotseSupportChatState?> state();

  /// Opens a conversation with [question]. The id is set when the result is
  /// [LotseSupportChatResult.started].
  Future<(LotseSupportChatResult, int?)> ask(String question);
}

/// [LotseSupportChat] on the generated client. The calls come in as functions,
/// so the mapping can be tested without a server.
///
/// Failures are logged with their kind only, never with a message text.
class ServerLotseSupportChat implements LotseSupportChat {
  /// Creates the support chat of the device [installId]. [sessionId] is
  /// stored with a question like with any feedback.
  ServerLotseSupportChat({
    required this.installId,
    required this.sessionId,
    required Future<generated.SupportChat> Function(String installId)
    getSupportChat,
    required SubmitFeedbackCall submitFeedback,
  }) : _get = getSupportChat,
       _submit = submitFeedback;

  /// Identifies this install.
  final String installId;

  /// Identifies this app start.
  final String sessionId;

  final Future<generated.SupportChat> Function(String) _get;
  final SubmitFeedbackCall _submit;

  @override
  Future<LotseSupportChatState?> state() async {
    try {
      final chat = await _get(installId);
      return LotseSupportChatState(
        enabled: chat.enabled,
        feedbackId: chat.feedbackId,
      );
    } catch (error) {
      debugPrint(
        'Lotse: could not load the support chat: ${error.runtimeType}',
      );
      return null;
    }
  }

  @override
  Future<(LotseSupportChatResult, int?)> ask(String question) async {
    try {
      final id = await _submit(
        installId,
        generated.FeedbackSubmission(
          category: generated.FeedbackCategory.question,
          message: question,
          sessionId: sessionId,
        ),
      );
      return (LotseSupportChatResult.started, id);
    } on generated.LotseSupportChatDisabledException {
      debugPrint('Lotse: the support chat is switched off.');
      return (LotseSupportChatResult.disabled, null);
    } on generated.LotseQuotaExceededException {
      debugPrint('Lotse: the feedback quota is used up.');
      return (LotseSupportChatResult.limitReached, null);
    } catch (error) {
      debugPrint('Lotse: could not send the question: ${error.runtimeType}');
      return (LotseSupportChatResult.failed, null);
    }
  }
}

/// The state of the support chat until a conversation exists: whether the
/// chat is on, the running conversation and the first question. Plain Dart,
/// the page only renders it. Once [feedbackId] is set the conversation itself
/// is a [LotseFeedbackThreadController].
class LotseSupportChatController extends ChangeNotifier {
  /// Creates the state on [_chat].
  LotseSupportChatController(this._chat);

  final LotseSupportChat _chat;
  bool _disposed = false;

  /// Whether the answer of the server is there.
  LotseLoadStatus get status => _status;
  LotseLoadStatus _status = LotseLoadStatus.loading;

  /// Whether the project accepts new questions. `false` until loaded.
  bool get enabled => _enabled;
  bool _enabled = false;

  /// The conversation to show, `null` while there is none.
  int? get feedbackId => _feedbackId;
  int? _feedbackId;

  /// `true` while the first question is on its way.
  bool get isSending => _sending;
  bool _sending = false;

  /// How the last question failed, `null` if it did not. The text stays in
  /// the field, so the user can try again.
  LotseSupportChatResult? get failure => _failure;
  LotseSupportChatResult? _failure;

  /// `true` if [question] can go out now.
  bool canAsk(String question) {
    final trimmed = question.trim();
    return !_sending &&
        _status == LotseLoadStatus.loaded &&
        _enabled &&
        _feedbackId == null &&
        trimmed.isNotEmpty &&
        trimmed.length <= maxFeedbackMessageLength;
  }

  /// Asks the server whether the chat is on and for the running conversation.
  Future<void> load() async {
    final state = await _chat.state();
    if (_disposed) return;
    if (state != null) {
      _enabled = state.enabled;
      _feedbackId = state.feedbackId;
      _status = LotseLoadStatus.loaded;
    } else {
      _status = LotseLoadStatus.failed;
    }
    notifyListeners();
  }

  /// Shows the spinner and loads again after a failed load.
  Future<void> retry() {
    _status = LotseLoadStatus.loading;
    notifyListeners();
    return load();
  }

  /// Opens the conversation with [question]. Returns `true` if the server
  /// took it; [feedbackId] is set then. Never throws.
  Future<bool> ask(String question) async {
    if (!canAsk(question)) return false;
    _sending = true;
    _failure = null;
    notifyListeners();

    final (result, id) = await _chat.ask(question.trim());
    if (_disposed) return false;
    _sending = false;
    switch (result) {
      case LotseSupportChatResult.started:
        _feedbackId = id;
      case LotseSupportChatResult.disabled:
        // Switched off since the page was loaded: the notice replaces the
        // field, there is nothing to try again.
        _enabled = false;
      case LotseSupportChatResult.limitReached:
      case LotseSupportChatResult.failed:
        _failure = result;
    }
    notifyListeners();
    return result == LotseSupportChatResult.started;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

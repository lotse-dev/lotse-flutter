import 'package:flutter/widgets.dart';
import 'lotse_log.dart';

/// Frames the opener waits for the app's navigator after a `LotseScope` has
/// attached its key. A router that resolves its first route asynchronously
/// builds the navigator a few frames after the scope.
const _maxFramesToWait = 120;

/// Opens the conversation of a feedback message on [navigator].
typedef LotseThreadOpenHandler =
    void Function(NavigatorState navigator, int feedbackId);

/// Brings a tapped reply push to the app's navigator.
///
/// A push can be tapped before anything is ready: the SDK learns about the
/// push that started the app during `Lotse.init`, which usually runs before
/// `runApp`. The opener therefore keeps the last request until three things
/// have come together: the request, the [handler] of the SDK and the navigator
/// behind the key of a `LotseScope`.
class LotseFeedbackOpener {
  GlobalKey<NavigatorState>? _navigatorKey;
  LotseThreadOpenHandler? _handler;
  int? _pending;
  int _framesWaited = 0;
  bool _frameScheduled = false;

  /// The conversation that is waiting to be opened, `null` without one.
  @visibleForTesting
  int? get pending => _pending;

  /// Forgets handler, key and request. The opener is shared, so tests that go
  /// through a `LotseScope` clean up with this.
  @visibleForTesting
  void reset() {
    _navigatorKey = null;
    _handler = null;
    _pending = null;
    _framesWaited = 0;
  }

  /// What opens a conversation, set by the SDK once it is initialised.
  set handler(LotseThreadOpenHandler? value) {
    _handler = value;
    _flush();
  }

  /// Called by a `LotseScope` with the navigator key of the app.
  void attach(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _framesWaited = 0;
    _flush();
  }

  /// Called by a `LotseScope` that goes away or changes its key.
  void detach(GlobalKey<NavigatorState> navigatorKey) {
    if (_navigatorKey == navigatorKey) _navigatorKey = null;
  }

  /// Opens the conversation [feedbackId] as soon as that is possible. A later
  /// request replaces one that is still waiting.
  void open(int feedbackId) {
    _pending = feedbackId;
    _framesWaited = 0;
    _flush();
  }

  void _flush() {
    final feedbackId = _pending;
    final handler = _handler;
    final key = _navigatorKey;
    if (feedbackId == null || handler == null || key == null) return;

    final navigator = key.currentState;
    if (navigator == null) {
      _waitAFrame();
      return;
    }
    _pending = null;
    try {
      handler(navigator, feedbackId);
    } catch (error) {
      lotseLog('could not open the conversation', error);
    }
  }

  /// The key is known but has no navigator yet: look again after the next
  /// frame, for a limited number of frames so a key that never gets a
  /// navigator does not keep the app rendering.
  void _waitAFrame() {
    if (_frameScheduled) return;
    if (_framesWaited >= _maxFramesToWait) {
      debugPrint(
        'Lotse: the navigator key of LotseScope has no navigator; the '
        'conversation was not opened.',
      );
      _pending = null;
      return;
    }
    _framesWaited++;
    _frameScheduled = true;
    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        _frameScheduled = false;
        _flush();
      })
      ..scheduleFrame();
  }
}

/// The opener shared by `Lotse` and `LotseScope`.
final lotseFeedbackOpener = LotseFeedbackOpener();

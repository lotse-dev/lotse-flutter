import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Holds on to links the platform pushes before the app's router exists and
/// hands them on once it does.
///
/// Android restores an app whose process it ended with the intent that first
/// started it, and delivers the link that reopens it a moment later as a route
/// push. `main` is usually still waiting then (`Firebase.initializeApp`,
/// `Lotse.init`), no router listens, and Flutter drops the push: the app opens
/// on its first screen instead of the link. A cold start is not affected, it
/// carries the link in the initial route.
///
/// [start] registers an observer that keeps the newest pushed route. After the
/// first frame, when `runApp` has built the router, the observer leaves and the
/// route goes out again on [SystemChannels.navigation], the way the engine sent
/// it, so the router navigates as if it had heard it in the first place. Links
/// that arrive later never pass through here.
class LotseLaunchLinks with WidgetsBindingObserver {
  LotseLaunchLinks._(this._binding);

  final WidgetsBinding _binding;
  RouteInformation? _pending;

  static LotseLaunchLinks? _current;

  /// Starts holding links on [binding] until its first frame. Calling it again
  /// before then does nothing.
  static void start(WidgetsBinding binding) {
    if (_current != null) return;
    final capture = _current = LotseLaunchLinks._(binding);
    binding.addObserver(capture);
    binding.addPostFrameCallback((_) => capture._release());
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    _pending = routeInformation;
    return Future.value(true);
  }

  void _release() {
    _binding.removeObserver(this);
    _current = null;
    final pending = _pending;
    if (pending == null) return;
    _pending = null;
    _binding.channelBuffers.push(
      SystemChannels.navigation.name,
      SystemChannels.navigation.codec.encodeMethodCall(
        MethodCall('pushRouteInformation', <String, Object?>{
          'location': pending.uri.toString(),
          'state': pending.state,
        }),
      ),
      (_) {},
    );
  }
}

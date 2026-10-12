import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Moves whenever the identity of this install ends, see `Lotse.reset`. The
/// pages of the SDK watch it through [LotseIdentityBoundary].
final lotseIdentityEpoch = ValueNotifier<int>(0);

/// Shows [child] for as long as the identity it was opened under lasts.
///
/// When [epoch] moves, the child is taken out of the tree in the same frame
/// and its route is removed. Taking it out disposes the page and with it the
/// controller, which closes its live stream, stops polling and ignores
/// answers still on their way.
/// So the next user of the app never sees what the previous one had open.
class LotseIdentityBoundary extends StatefulWidget {
  /// Creates the boundary around [child].
  const LotseIdentityBoundary({super.key, required this.child, this.epoch});

  /// The page that belongs to one identity.
  final Widget child;

  /// Replaced in tests; [lotseIdentityEpoch] otherwise.
  final ValueListenable<int>? epoch;

  @override
  State<LotseIdentityBoundary> createState() => _LotseIdentityBoundaryState();
}

class _LotseIdentityBoundaryState extends State<LotseIdentityBoundary> {
  late final ValueListenable<int> _epoch;
  late final int _openedIn;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    _epoch = widget.epoch ?? lotseIdentityEpoch;
    _openedIn = _epoch.value;
    _epoch.addListener(_onEpoch);
  }

  void _onEpoch() {
    if (_ended || _epoch.value == _openedIn || !mounted) return;
    setState(() => _ended = true);
    final route = ModalRoute.of(context);
    if (route == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route.isActive) route.navigator?.removeRoute(route);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    _epoch.removeListener(_onEpoch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _ended ? const SizedBox.shrink() : widget.child;
}

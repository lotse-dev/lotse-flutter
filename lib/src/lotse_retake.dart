import 'dart:async';

import 'package:flutter/material.dart';

/// What the user picked on the floating retake bar.
enum LotseRetakeChoice {
  /// Capture the screen as it is now.
  capture,

  /// Back to the sheet with the screenshot it had.
  cancel,
}

/// One open "Retake": what the floating bar shows and how it looks. The bar
/// sits outside the app's `MaterialApp`, so it brings the themes and the text
/// direction of the sheet along.
class LotseRetakeRequest {
  /// Creates a request with the bar's texts, [themes] and [textDirection].
  LotseRetakeRequest({
    required this.hint,
    required this.captureLabel,
    required this.cancelLabel,
    required this.themes,
    required this.textDirection,
  });

  /// Line above the buttons.
  final String hint;

  /// Label of the button that captures.
  final String captureLabel;

  /// Label of the button that goes back to the sheet.
  final String cancelLabel;

  /// The themes of the app, captured where the sheet was opened.
  final CapturedThemes themes;

  /// The text direction of the app.
  final TextDirection textDirection;

  final _answer = Completer<LotseRetakeChoice?>();
}

/// Holds the retake that is open, if any. Owned by the `LotseScope`, which
/// shows the bar while [current] is set.
class LotseRetakeController {
  /// The open request, or `null` when there is no bar.
  final ValueNotifier<LotseRetakeRequest?> current = ValueNotifier(null);

  /// Where the user last dragged the bar to, its top left corner. The next
  /// retake starts there, so the bar is moved out of the way only once.
  Offset? position;

  /// Shows the bar for [request] and completes with the user's choice. A
  /// request that another one replaces, or that the scope drops when it goes
  /// away, completes with `null`.
  Future<LotseRetakeChoice?> request(LotseRetakeRequest request) {
    _finish(null);
    current.value = request;
    return request._answer.future;
  }

  /// Completes the open request with [choice] and hides the bar.
  void answer(LotseRetakeChoice choice) => _finish(choice);

  void _finish(LotseRetakeChoice? choice) {
    final open = current.value;
    if (open == null) return;
    current.value = null;
    if (!open._answer.isCompleted) open._answer.complete(choice);
  }

  /// Drops an open request.
  void dispose() {
    _finish(null);
    current.dispose();
  }
}

/// The floating bar of an open retake. It lies above the app but outside the
/// captured boundary, so it is never in the screenshot. The user drags it by
/// any spot that is not a button, so it never covers what they need to tap.
class LotseRetakeBar extends StatefulWidget {
  /// Creates the bar for [request], answering through [controller].
  const LotseRetakeBar({
    required this.controller,
    required this.request,
    super.key,
  });

  /// Where the choice goes.
  final LotseRetakeController controller;

  /// What the bar shows.
  final LotseRetakeRequest request;

  @override
  State<LotseRetakeBar> createState() => _LotseRetakeBarState();
}

class _LotseRetakeBarState extends State<LotseRetakeBar> {
  final _barKey = GlobalKey(debugLabel: 'LotseRetakeBar');

  /// Top left corner of the bar once it has been dragged, in this or an
  /// earlier retake; before that it sits at the bottom centre.
  late Offset? _position = widget.controller.position;

  static const _margin = 16.0;

  void _drag(DragUpdateDetails details, Size screen, EdgeInsets padding) {
    final box = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final start = _position ?? box.localToGlobal(Offset.zero);
    final size = box.size;
    final moved = start + details.delta;
    final maxX = screen.width - size.width;
    final maxY = screen.height - size.height - padding.bottom;
    setState(() {
      _position = widget.controller.position = Offset(
        moved.dx.clamp(0, maxX < 0 ? 0 : maxX),
        moved.dy.clamp(padding.top, maxY < padding.top ? padding.top : maxY),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return request.themes.wrap(
      Directionality(
        textDirection: request.textDirection,
        child: MediaQuery.fromView(
          view: View.of(context),
          child: Builder(
            builder: (context) {
              final media = MediaQuery.of(context);
              final bar = _Bar(
                key: _barKey,
                request: request,
                onDrag: (details) => _drag(details, media.size, media.padding),
                onCapture: () =>
                    widget.controller.answer(LotseRetakeChoice.capture),
                onCancel: () =>
                    widget.controller.answer(LotseRetakeChoice.cancel),
              );
              final position = _position;
              if (position == null) {
                return Positioned(
                  left: _margin,
                  right: _margin,
                  bottom: media.padding.bottom + _margin * 3,
                  child: Center(child: bar),
                );
              }
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: bar,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.request,
    required this.onDrag,
    required this.onCapture,
    required this.onCancel,
    super.key,
  });

  final LotseRetakeRequest request;
  final GestureDragUpdateCallback onDrag;
  final VoidCallback onCapture;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return GestureDetector(
      onPanUpdate: onDrag,
      child: Material(
        color: scheme.surfaceContainerHigh,
        elevation: 6,
        shadowColor: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.drag_indicator,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      request.hint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Wraps where the labels are long, German at the start
              // position among them.
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: onCapture,
                      icon: const Icon(Icons.screenshot_outlined),
                      label: Text(request.captureLabel),
                    ),
                    TextButton(
                      onPressed: onCancel,
                      child: Text(request.cancelLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

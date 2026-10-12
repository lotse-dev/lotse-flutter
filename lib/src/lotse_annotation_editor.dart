import 'package:flutter/material.dart';

import 'lotse_annotation.dart';
import 'lotse_capture.dart';
import 'lotse_feedback_texts.dart';

/// Burns strokes into a screenshot. `mergeLotseAnnotation` outside of tests.
typedef LotseAnnotationMerger =
    Future<LotseCaptureResult> Function(
      LotseScreenshot screenshot,
      List<LotseStroke> strokes,
    );

/// What the editor hands back on "done".
class LotseAnnotationResult {
  /// Creates a result.
  const LotseAnnotationResult({
    required this.strokes,
    required this.screenshot,
  });

  /// The strokes the user kept. Empty if everything was undone.
  final List<LotseStroke> strokes;

  /// The screenshot with [strokes] burned in.
  final LotseScreenshot screenshot;
}

/// A full-screen page on which the user draws on [screenshot] with one pen.
///
/// Pops its route with a [LotseAnnotationResult] on "done" and with `null`
/// on "cancel". Holds no drawing logic: strokes live in a
/// [LotseAnnotationController], the image is merged by [merge].
class LotseAnnotationEditor extends StatefulWidget {
  /// Creates the editor for [screenshot], starting with [strokes].
  const LotseAnnotationEditor({
    required this.screenshot,
    required this.texts,
    this.strokes = const [],
    this.merge = mergeLotseAnnotation,
    super.key,
  });

  /// The screenshot as it was captured, without strokes.
  final LotseScreenshot screenshot;

  /// The strokes of an earlier session. They can be undone like new ones.
  final List<LotseStroke> strokes;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Burns the strokes into the screenshot.
  final LotseAnnotationMerger merge;

  @override
  State<LotseAnnotationEditor> createState() => _LotseAnnotationEditorState();
}

class _LotseAnnotationEditorState extends State<LotseAnnotationEditor> {
  late final _controller = LotseAnnotationController(strokes: widget.strokes);

  // One pen: a second finger on the image does not start a second stroke.
  int? _pointer;
  bool _saving = false;
  bool _failed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _done() async {
    if (_saving) return;
    _controller.endStroke();
    final strokes = _controller.strokes;
    setState(() {
      _saving = true;
      _failed = false;
    });

    LotseCaptureResult result;
    try {
      result = await widget.merge(widget.screenshot, strokes);
    } catch (error) {
      // A merger must not throw, but the editor must not get stuck if one does.
      debugPrint('Lotse: the annotation merger threw: ${error.runtimeType}');
      result = const LotseCaptureFailed(LotseCaptureFailure.unknown);
    }
    if (!mounted) return;
    switch (result) {
      case LotseCaptureSuccess(:final screenshot):
        Navigator.of(
          context,
        ).pop(LotseAnnotationResult(strokes: strokes, screenshot: screenshot));
      case LotseCaptureFailed():
        setState(() {
          _saving = false;
          _failed = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          tooltip: texts.annotateCancel,
        ),
        // Undo, clear and done leave little room on a narrow phone: the
        // title shrinks instead of being cut off.
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(texts.annotateTitle),
        ),
        actions: [
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final idle = _saving || _controller.isEmpty;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: idle ? null : _controller.undo,
                    icon: const Icon(Icons.undo),
                    tooltip: texts.annotateUndo,
                  ),
                  IconButton(
                    onPressed: idle ? null : _controller.clear,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: texts.annotateClear,
                  ),
                ],
              );
            },
          ),
          TextButton(
            onPressed: _saving ? null : _done,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(texts.annotateDone),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: _buildCanvas(context)),
              ),
            ),
            if (_failed)
              Container(
                width: double.infinity,
                color: theme.colorScheme.errorContainer,
                padding: const EdgeInsets.all(12),
                child: Text(
                  texts.annotateFailed,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvas(BuildContext context) {
    final screenshot = widget.screenshot;
    return AspectRatio(
      aspectRatio: screenshot.width / screenshot.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          // Strokes are relative to the image, whatever size it is shown at.
          Offset relative(Offset local) =>
              Offset(local.dx / size.width, local.dy / size.height);

          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              if (_saving || _pointer != null) return;
              _pointer = event.pointer;
              _controller.startStroke(relative(event.localPosition));
            },
            onPointerMove: (event) {
              if (event.pointer != _pointer) return;
              _controller.extendStroke(relative(event.localPosition));
            },
            onPointerUp: _release,
            onPointerCancel: _release,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: CustomPaint(
                foregroundPainter: _StrokePainter(_controller),
                child: Image.memory(
                  screenshot.png,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                  semanticLabel: widget.texts.screenshotLabel,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _release(PointerEvent event) {
    if (event.pointer != _pointer) return;
    _pointer = null;
    _controller.endStroke();
  }
}

class _StrokePainter extends CustomPainter {
  _StrokePainter(this.controller) : super(repaint: controller);

  final LotseAnnotationController controller;

  @override
  void paint(Canvas canvas, Size size) =>
      paintLotseStrokes(canvas, size, controller.strokes);

  @override
  bool shouldRepaint(_StrokePainter oldDelegate) =>
      oldDelegate.controller != controller;
}

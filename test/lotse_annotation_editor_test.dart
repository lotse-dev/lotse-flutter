import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_annotation.dart';
import 'package:lotse/src/lotse_annotation_editor.dart';
import 'package:lotse/src/lotse_capture.dart';

// A PNG of one pixel. The editor lays the image out by the size the
// screenshot states, so the content does not matter here.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGA'
  'WjR9awAAAABJRU5ErkJggg==',
);

final _captured = LotseScreenshot(
  png: _png,
  width: 200,
  height: 400,
  pixelRatio: 1,
);
final _merged = LotseScreenshot(
  png: _png,
  width: 200,
  height: 400,
  pixelRatio: 1,
);

/// Records what it is asked to merge and answers with [results] in order,
/// then with a success carrying [_merged]. With [gate] set, every answer waits
/// for it.
class _FakeMerger {
  _FakeMerger({List<LotseCaptureResult> results = const [], this.gate})
    : _results = [...results];

  final List<LotseCaptureResult> _results;
  final Completer<void>? gate;
  final calls = <List<LotseStroke>>[];

  Future<LotseCaptureResult> call(
    LotseScreenshot screenshot,
    List<LotseStroke> strokes,
  ) async {
    calls.add(strokes);
    await gate?.future;
    return _results.isEmpty
        ? LotseCaptureSuccess(_merged)
        : _results.removeAt(0);
  }
}

/// What the editor popped with; `closed` tells a `null` from "still open".
class _Outcome {
  LotseAnnotationResult? result;
  bool closed = false;
}

/// Opens the editor from a button and records what it pops with.
Future<_Outcome> _pumpEditor(
  WidgetTester tester,
  _FakeMerger merger, {
  List<LotseStroke> strokes = const [],
}) async {
  final outcome = _Outcome();
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            outcome.result = await Navigator.of(context).push(
              MaterialPageRoute<LotseAnnotationResult>(
                builder: (context) => LotseAnnotationEditor(
                  screenshot: _captured,
                  strokes: strokes,
                  texts: LotseFeedbackTexts.english,
                  merge: merger.call,
                ),
              ),
            );
            outcome.closed = true;
          },
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return outcome;
}

/// The area the user draws on.
Rect _canvas(WidgetTester tester) => tester.getRect(
  find.descendant(
    of: find.byType(LotseAnnotationEditor),
    matching: find.byType(AspectRatio),
  ),
);

/// Draws a horizontal line at the relative height [dy].
Future<void> _drawLine(WidgetTester tester, double dy) async {
  final canvas = _canvas(tester);
  final y = canvas.top + canvas.height * dy;
  final gesture = await tester.startGesture(Offset(canvas.left, y));
  await gesture.moveTo(Offset(canvas.center.dx, y));
  await gesture.moveTo(Offset(canvas.right, y));
  await gesture.up();
  await tester.pump();
}

IconButton _button(WidgetTester tester, String tooltip) =>
    tester.widget<IconButton>(
      find.ancestor(
        of: find.byTooltip(tooltip),
        matching: find.byType(IconButton),
      ),
    );

void main() {
  group('Given the annotation editor', () {
    testWidgets('when it opens '
        'then the image keeps its aspect ratio and there is nothing to undo', (
      tester,
    ) async {
      await _pumpEditor(tester, _FakeMerger());

      expect(find.text('Mark the screenshot'), findsOneWidget);
      final canvas = _canvas(tester);
      expect(canvas.width / canvas.height, closeTo(0.5, 0.01));
      expect(_button(tester, 'Undo').onPressed, isNull);
      expect(_button(tester, 'Clear').onPressed, isNull);
    });

    testWidgets('when the user draws and is done '
        'then the stroke is relative to the image and the merged screenshot '
        'is handed back', (tester) async {
      final merger = _FakeMerger();
      final outcome = await _pumpEditor(tester, merger);

      await _drawLine(tester, 0.25);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.byType(LotseAnnotationEditor), findsNothing);
      expect(outcome.result!.screenshot, same(_merged));
      final points = outcome.result!.strokes.single.points;
      expect(points.first.dx, closeTo(0, 0.001));
      expect(points[1].dx, closeTo(0.5, 0.001));
      expect(points.last.dx, closeTo(1, 0.001));
      for (final point in points) {
        expect(point.dy, closeTo(0.25, 0.001));
      }
      expect(merger.calls.single, hasLength(1));
    });

    testWidgets('when undo is tapped then only the last stroke goes', (
      tester,
    ) async {
      final outcome = await _pumpEditor(tester, _FakeMerger());
      await _drawLine(tester, 0.2);
      await _drawLine(tester, 0.8);

      await tester.tap(find.byTooltip('Undo'));
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      final stroke = outcome.result!.strokes.single;
      expect(stroke.points.first.dy, closeTo(0.2, 0.001));
    });

    testWidgets('when clear is tapped '
        'then every stroke goes and the buttons are disabled again', (
      tester,
    ) async {
      final outcome = await _pumpEditor(tester, _FakeMerger());
      await _drawLine(tester, 0.2);
      await _drawLine(tester, 0.8);

      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();

      expect(_button(tester, 'Undo').onPressed, isNull);
      expect(_button(tester, 'Clear').onPressed, isNull);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(outcome.result!.strokes, isEmpty);
    });

    testWidgets('when it opens with strokes of an earlier visit '
        'then they can be undone', (tester) async {
      final outcome = await _pumpEditor(
        tester,
        _FakeMerger(),
        strokes: [
          LotseStroke(const [Offset(0, 0), Offset(1, 1)]),
        ],
      );

      await tester.tap(find.byTooltip('Undo'));
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(outcome.result!.strokes, isEmpty);
    });

    testWidgets('when a second finger touches the image '
        'then it does not start a second stroke', (tester) async {
      final outcome = await _pumpEditor(tester, _FakeMerger());
      final canvas = _canvas(tester);

      final first = await tester.startGesture(canvas.topLeft, pointer: 1);
      final second = await tester.startGesture(canvas.center, pointer: 2);
      await second.moveTo(canvas.bottomRight);
      await first.moveTo(canvas.topRight);
      await second.up();
      await first.up();
      await tester.pump();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      final points = outcome.result!.strokes.single.points;
      expect(points.first, const Offset(0, 0));
      expect(points.last.dx, closeTo(1, 0.001));
      expect(points.last.dy, closeTo(0, 0.001));
    });

    testWidgets('when cancel is tapped then nothing is handed back', (
      tester,
    ) async {
      final merger = _FakeMerger();
      final outcome = await _pumpEditor(tester, merger);
      await _drawLine(tester, 0.5);

      await tester.tap(find.byTooltip('Cancel'));
      await tester.pumpAndSettle();

      expect(outcome.closed, isTrue);
      expect(outcome.result, isNull);
      expect(merger.calls, isEmpty);
    });

    testWidgets('when merging is under way '
        'then the editor shows progress and takes no more strokes', (
      tester,
    ) async {
      final merger = _FakeMerger(gate: Completer<void>());
      final outcome = await _pumpEditor(tester, merger);
      await _drawLine(tester, 0.2);

      await tester.tap(find.text('Done'));
      await tester.pump();
      await _drawLine(tester, 0.8);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(_button(tester, 'Undo').onPressed, isNull);
      expect(_button(tester, 'Cancel').onPressed, isNull);

      merger.gate!.complete();
      await tester.pumpAndSettle();
      expect(outcome.result!.strokes, hasLength(1));
    });

    testWidgets('when merging fails '
        'then the editor says so, keeps the strokes and done tries again', (
      tester,
    ) async {
      final merger = _FakeMerger(
        results: [const LotseCaptureFailed(LotseCaptureFailure.tooLarge)],
      );
      final outcome = await _pumpEditor(tester, merger);
      await _drawLine(tester, 0.5);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.byType(LotseAnnotationEditor), findsOneWidget);
      expect(
        find.text(LotseFeedbackTexts.english.annotateFailed),
        findsOneWidget,
      );
      expect(outcome.closed, isFalse);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(outcome.result!.strokes, hasLength(1));
      expect(merger.calls, hasLength(2));
    });
  });
}

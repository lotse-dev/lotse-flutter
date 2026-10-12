import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_identity_boundary.dart';
import 'package:lotse/src/lotse_replay_buffer.dart';
import 'package:lotse/src/lotse_replay_recorder.dart';
import 'package:lotse/src/lotse_screens.dart';

final _boundary = GlobalKey();

/// A 800 × 600 view: a box that changes colour and a text field.
class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  var count = 0;

  void increment() => setState(() => count++);

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: RepaintBoundary(
      key: _boundary,
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test fonts draw every glyph as the same box, so the change
              // is a colour.
              Container(
                width: 40,
                height: 40,
                color: count.isEven ? Colors.red : Colors.blue,
              ),
              // Without decoration: its underline lies outside the masked input
              // and rightly changes colour on focus.
              const SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: ''),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  late int now;
  late LotseReplayRecorder recorder;

  /// Lets the capture that a frame started finish. Reading pixels and
  /// encoding PNGs need the real event loop, and what follows each step runs
  /// in the fake zone of the test, so both take turns.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      // Draws nothing unless a frame was asked for; runs the microtasks.
      await tester.pump();
    }
  }

  Future<void> start(WidgetTester tester) async {
    now = 0;
    await tester.pumpWidget(const _App());
    recorder = LotseReplayRecorder(
      boundaryKey: _boundary,
      options: const LotseReplayOptions(seconds: 30),
      clock: () => now,
      wallClock: () => DateTime.utc(
        2026,
        9,
        28,
        11,
        25,
        41,
      ).add(Duration(milliseconds: now)),
      // An isolate would finish outside the fake time of the test.
      compare: (job) async => runLotseReplayDiff(job),
    );
    tester.binding.scheduleFrame();
    await tester.pump();
    await settle(tester);
  }

  tearDown(() => lotseCurrentScreen.value = null);

  /// A test that disposes the recorder at its end: its timer would still be
  /// pending when the test checks for timers, before any tear-down runs.
  void recorderTest(String description, WidgetTesterCallback body) =>
      testWidgets(description, (tester) async {
        await body(tester);
        recorder.dispose();
      });

  recorderTest('the first frame is a keyframe in logical pixels', (
    tester,
  ) async {
    await start(tester);

    final frame = recorder.buffer.frames.single;
    expect(frame.keyframe, isTrue);
    expect((frame.width, frame.height), (800, 600));
    expect(frame.png.sublist(1, 4), 'PNG'.codeUnits);
  });

  recorderTest('a small change after the interval is a small cut-out', (
    tester,
  ) async {
    await start(tester);

    now = 600;
    tester.state<_AppState>(find.byType(_App)).increment();
    await tester.pump();
    await settle(tester);

    final frames = recorder.buffer.frames;
    expect(frames, hasLength(2));
    final cut = frames.last;
    expect(cut.keyframe, isFalse);
    expect(cut.tMs, 600);
    expect(cut.rect.x, 0);
    expect(cut.rect.y, 0);
    expect(cut.rect.w * cut.rect.h, lessThan(800 * 600 / 4));
  });

  recorderTest('frames within the interval wait for it', (tester) async {
    await start(tester);

    now = 100;
    tester.state<_AppState>(find.byType(_App)).increment();
    await tester.pump();
    await settle(tester);
    expect(recorder.buffer.frames, hasLength(1));

    // The timer counts fake time, the clock is set by hand; both pass the
    // interval here.
    now = 600;
    await tester.pump(const Duration(milliseconds: 600));
    await settle(tester);
    expect(recorder.buffer.frames, hasLength(2));
  });

  recorderTest('typing into a masked text field records nothing new', (
    tester,
  ) async {
    await start(tester);

    now = 600;
    await tester.enterText(find.byType(TextField), 'secret');
    await tester.pump();
    await settle(tester);
    // The cursor blinks in the field; still masked.
    now = 1200;
    await tester.pump(const Duration(milliseconds: 600));
    await settle(tester);

    expect(recorder.buffer.frames.where((f) => !f.keyframe), isEmpty);
  });

  recorderTest('taps, screens, holds and the app going away are marks', (
    tester,
  ) async {
    await start(tester);

    now = 100;
    recorder.tap(const Offset(10, 20));
    lotseCurrentScreen.value = 'cart';
    now = 200;
    recorder.hold();
    recorder.tap(const Offset(1, 1));
    now = 300;
    recorder.release();

    expect(recorder.buffer.marks.map((m) => (m.tMs, m.kind)), [
      (100, LotseReplayMarkKind.tap),
      (100, LotseReplayMarkKind.screen),
      (200, LotseReplayMarkKind.pause),
      (300, LotseReplayMarkKind.resume),
    ]);
    final tap = recorder.buffer.marks.first;
    expect((tap.x, tap.y), (10, 20));
    expect(recorder.buffer.marks[1].screen, 'cart');
    await settle(tester);
  });

  recorderTest('idle waits for a capture that is still running', (
    tester,
  ) async {
    await start(tester);
    var idle = false;
    unawaited(recorder.idle.then((_) => idle = true));
    await tester.pump();
    expect(idle, isTrue);

    now = 600;
    tester.state<_AppState>(find.byType(_App)).increment();
    await tester.pump();
    // The frame started a capture; holding does not end it.
    recorder.hold();
    idle = false;
    unawaited(recorder.idle.then((_) => idle = true));
    await tester.pump();
    expect(idle, isFalse);

    await settle(tester);
    expect(idle, isTrue);
    expect(recorder.buffer.frames, hasLength(2));
  });

  recorderTest('while held nothing is captured', (tester) async {
    await start(tester);

    recorder.hold();
    now = 600;
    tester.state<_AppState>(find.byType(_App)).increment();
    await tester.pump();
    await settle(tester);

    expect(recorder.buffer.frames, hasLength(1));
  });

  recorderTest('when the identity ends then nothing of the previous user '
      'stays in the buffer', (tester) async {
    await start(tester);
    recorder.tap(const Offset(1, 1));
    expect(recorder.buffer.isEmpty, isFalse);

    lotseIdentityEpoch.value++;

    expect(recorder.buffer.isEmpty, isTrue);
    expect(recorder.buffer.marks, isEmpty);
  });

  recorderTest('the chunks of a recording start with a keyframe', (
    tester,
  ) async {
    await start(tester);
    now = 2000;

    final chunk = recorder.chunks().single;
    expect(chunk.frames.first.keyframe, isTrue);
    expect(chunk.endMs, 2000);
  });

  recorderTest('the chunks carry the wall clock of their end, the clock of '
      'the events (F11)', (tester) async {
    await start(tester);
    now = 2000;

    expect(
      recorder.chunks().single.endedAt,
      DateTime.utc(2026, 9, 28, 11, 25, 43),
    );
  });
}

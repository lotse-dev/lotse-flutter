import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_feedback.dart';
import 'package:lotse/src/lotse_replay_buffer.dart';
import 'package:lotse/src/lotse_replay_upload.dart';

LotseReplayChunk _chunk(int index, int count) => LotseReplayChunk(
  index: index,
  count: count,
  startMs: index * 1000,
  endMs: index * 1000 + 1000,
  width: 40,
  height: 30,
  frames: [
    LotseReplayFrame(
      tMs: index * 1000,
      rect: (x: 0, y: 0, w: 40, h: 30),
      png: Uint8List.fromList([1, 2, 3]),
      keyframe: true,
      width: 40,
      height: 30,
    ),
    LotseReplayFrame(
      tMs: index * 1000 + 500,
      rect: (x: 16, y: 0, w: 16, h: 16),
      png: Uint8List.fromList([4, 5]),
      keyframe: false,
      width: 40,
      height: 30,
    ),
  ],
  marks: [
    LotseReplayMark(
      tMs: index * 1000 + 100,
      kind: LotseReplayMarkKind.tap,
      x: 20,
      y: 10,
    ),
    LotseReplayMark(
      tMs: index * 1000 + 200,
      kind: LotseReplayMarkKind.screen,
      screen: 'cart',
    ),
  ],
);

Future<LotseFeedbackSendResult> _sent(LotseFeedbackDraft _) async =>
    LotseFeedbackSendResult.sent;

void main() {
  group('LotseFeedbackController with a recording', () {
    test('without a recording nothing can be attached', () {
      final none = LotseFeedbackController(_sent);
      final empty = LotseFeedbackController(_sent, replay: () => []);
      addTearDown(none.dispose);
      addTearDown(empty.dispose);

      expect(none.replayAvailable, isFalse);
      expect(empty.replayAvailable, isFalse);
      expect((empty..message = 'x').draft.replay, isNull);
    });

    test('the switch starts as the app says and decides what the draft '
        'carries', () {
      final chunks = [_chunk(0, 1)];
      final controller = LotseFeedbackController(
        _sent,
        replay: () => chunks,
        replaySeconds: 30,
      )..message = 'Stuck';
      addTearDown(controller.dispose);

      expect(controller.replayAvailable, isTrue);
      expect(controller.replaySeconds, 30);
      expect(controller.attachReplay, isTrue);
      expect(controller.draft.replay, chunks);

      controller.attachReplay = false;
      expect(controller.draft.replay, isNull);

      final off = LotseFeedbackController(
        _sent,
        replay: () => chunks,
        attachReplay: false,
      );
      addTearDown(off.dispose);
      expect(off.attachReplay, isFalse);
    });

    test('while sending the switch cannot change', () async {
      final gate = Completer<LotseFeedbackSendResult>();
      final controller = LotseFeedbackController(
        (_) => gate.future,
        replay: () => [_chunk(0, 1)],
      )..message = 'Stuck';
      addTearDown(controller.dispose);

      final sending = controller.send();
      controller.attachReplay = false;
      expect(controller.attachReplay, isTrue);
      gate.complete(LotseFeedbackSendResult.sent);
      await sending;
    });
  });

  group('sendLotseFeedback with a replay', () {
    LotseFeedbackDraft draft(List<LotseReplayChunk>? replay) =>
        LotseFeedbackDraft(
          category: LotseFeedbackCategory.bug,
          message: 'Stuck',
          replay: replay,
        );

    test('after the message the replay goes up with its id, without holding '
        'the result', () async {
      final uploads = <(int, int)>[];
      final gate = Completer<void>();

      final result = await sendLotseFeedback(
        (_, _, {screenshot}) async => 42,
        installId: '',
        sessionId: 's',
        draft: draft([_chunk(0, 2), _chunk(1, 2)]),
        uploadReplay: (id, chunks) async {
          await gate.future;
          uploads.add((id, chunks.length));
        },
      );

      expect(result, LotseFeedbackSendResult.sent);
      expect(uploads, isEmpty, reason: 'the sheet does not wait');
      gate.complete();
      await pumpEventQueue();
      expect(uploads, [(42, 2)]);
    });

    test('a failed message sends no replay, and no replay means no '
        'upload', () async {
      var uploads = 0;
      Future<void> upload(int _, List<LotseReplayChunk> _) async => uploads++;

      await sendLotseFeedback(
        (_, _, {screenshot}) async => throw StateError('offline'),
        installId: '',
        sessionId: 's',
        draft: draft([_chunk(0, 1)]),
        uploadReplay: upload,
      );
      await sendLotseFeedback(
        (_, _, {screenshot}) async => 1,
        installId: '',
        sessionId: 's',
        draft: draft(null),
        uploadReplay: upload,
      );
      await pumpEventQueue();

      expect(uploads, 0);
    });
  });

  group('uploadLotseReplay', () {
    test('chunks go up newest first and stop at the first failure', () async {
      final sent = <int>[];
      final count = await uploadLotseReplay(
        (id, chunk) async {
          if (chunk.index == 0) throw StateError('offline');
          sent.add(chunk.index);
        },
        7,
        [_chunk(0, 3), _chunk(1, 3), _chunk(2, 3)],
      );

      expect(sent, [2, 1]);
      expect(count, 2);
    });

    test('a chunk reaches the server in the generated types unchanged', () {
      final endedAt = DateTime.utc(2026, 9, 28, 11, 25, 41);
      final chunk = generatedReplayChunk(_chunk(1, 2).endingAt(endedAt));

      expect((chunk.index, chunk.count), (1, 2));
      expect((chunk.startMs, chunk.endMs), (1000, 2000));
      expect((chunk.width, chunk.height), (40, 30));
      final cut = chunk.frames.last;
      expect((cut.tMs, cut.x, cut.y, cut.w, cut.h), (1500, 16, 0, 16, 16));
      expect(Uint8List.sublistView(cut.png), [4, 5]);
      expect(chunk.marks.map((m) => m.kind), [
        generated.ReplayMarkKind.tap,
        generated.ReplayMarkKind.screen,
      ]);
      expect((chunk.marks.first.x, chunk.marks.first.y), (20, 10));
      expect(chunk.marks.last.screen, 'cart');
      expect(chunk.endedAt, endedAt);
    });
  });
}

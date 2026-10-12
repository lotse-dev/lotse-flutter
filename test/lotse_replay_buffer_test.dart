import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_replay_buffer.dart';
import 'package:lotse/src/lotse_replay_diff.dart';

LotseReplayFrame _key(int t, {int bytes = 100, int w = 400, int h = 800}) =>
    LotseReplayFrame(
      tMs: t,
      rect: (x: 0, y: 0, w: w, h: h),
      png: Uint8List(bytes),
      keyframe: true,
      width: w,
      height: h,
    );

LotseReplayFrame _cut(
  int t, {
  int bytes = 10,
  LotseReplayRect rect = (x: 0, y: 0, w: 16, h: 16),
}) => LotseReplayFrame(
  tMs: t,
  rect: rect,
  png: Uint8List(bytes),
  keyframe: false,
  width: 400,
  height: 800,
);

LotseReplayMark _screenAt(int t, String screen) =>
    LotseReplayMark(tMs: t, kind: LotseReplayMarkKind.screen, screen: screen);

LotseReplayMark _tapAt(int t) =>
    LotseReplayMark(tMs: t, kind: LotseReplayMarkKind.tap, x: 1, y: 2);

void main() {
  group('LotseReplayBuffer', () {
    test('a cut-out before any keyframe is dropped', () {
      final buffer = LotseReplayBuffer(windowMs: 60000)..add(_cut(0));
      expect(buffer.isEmpty, isTrue);
      expect(buffer.byteSize, 0);
    });

    test('trimming drops whole segments once the next one covers the window '
        'start, and keeps the newest', () {
      final buffer = LotseReplayBuffer(windowMs: 60000)
        ..add(_key(0))
        ..add(_cut(5000))
        ..add(_key(10000))
        ..add(_cut(15000))
        ..add(_key(70000))
        ..addMark(_tapAt(3000))
        ..addMark(_tapAt(12000));

      buffer.trim(75000);

      // Window starts at 15000: the segment from 10000 still covers it.
      expect(buffer.frames.map((f) => f.tMs), [10000, 15000, 70000]);
      expect(buffer.marks.map((m) => m.tMs), [12000]);
      expect(buffer.byteSize, 210);

      buffer.trim(500000);
      expect(buffer.frames.map((f) => f.tMs), [70000]);
    });

    test('trimming keeps the screen the first frame shows', () {
      final buffer = LotseReplayBuffer(windowMs: 60000)
        ..addMark(_screenAt(0, 'home'))
        ..addMark(_screenAt(4000, 'catalog'))
        ..add(_key(5000))
        ..add(_key(70000))
        ..addMark(_screenAt(71000, 'product'));

      buffer.trim(75000);

      expect(buffer.marks.map((m) => (m.tMs, m.screen)), [
        (5000, 'catalog'),
        (71000, 'product'),
      ]);
    });

    test('after a still screen the chunks begin at the window start, with '
        'what the screen showed then', () {
      final buffer = LotseReplayBuffer(windowMs: 60000)
        ..addMark(_screenAt(0, 'home'))
        ..add(_key(0))
        ..add(_cut(1000))
        ..addMark(_tapAt(2000))
        ..add(_cut(150000))
        ..addMark(_tapAt(151000));

      final chunk = buffer.chunks(200000).single;

      // The window begins at 140000; nothing before it is played.
      expect(chunk.frames.map((f) => (f.tMs, f.keyframe)), [
        (0, true),
        (0, false),
        (10000, false),
      ]);
      expect(chunk.endMs, 60000);
      expect(chunk.marks.map((m) => (m.tMs, m.kind)), [
        (0, LotseReplayMarkKind.screen),
        (11000, LotseReplayMarkKind.tap),
      ]);
      expect(chunk.marks.first.screen, 'home');
    });

    test('a recording shorter than the window keeps its times', () {
      final buffer = LotseReplayBuffer(windowMs: 60000)
        ..add(_key(1000))
        ..add(_cut(3000));

      final chunk = buffer.chunks(10000).single;

      expect(chunk.frames.map((f) => f.tMs), [0, 2000]);
      expect(chunk.endMs, 9000);
    });

    test('over the byte limit the oldest segments go first', () {
      final buffer = LotseReplayBuffer(windowMs: 60000, maxBytes: 250)
        ..add(_key(0))
        ..add(_key(1000))
        ..add(_key(2000));

      buffer.trim(2000);

      expect(buffer.frames.map((f) => f.tMs), [1000, 2000]);
      expect(buffer.byteSize, 200);
    });
  });

  group('splitLotseReplay', () {
    test('one small buffer is one chunk with times from its start', () {
      final chunks = splitLotseReplay(
        [
          [_key(5000), _cut(5500)],
        ],
        [_tapAt(4000), _tapAt(5200)],
        nowMs: 9000,
      );

      final chunk = chunks.single;
      expect((chunk.index, chunk.count), (0, 1));
      expect((chunk.startMs, chunk.endMs), (0, 4000));
      expect(chunk.frames.map((f) => f.tMs), [0, 500]);
      expect(chunk.frames.first.keyframe, isTrue);
      expect(chunk.marks.map((m) => m.tMs), [200]);
      expect((chunk.width, chunk.height), (400, 800));
    });

    test('segments go into chunks of at most the byte limit, each starting '
        'with a keyframe, marks with the chunk they fall in', () {
      final chunks = splitLotseReplay(
        [
          [_key(0, bytes: 60)],
          [_key(1000, bytes: 60)],
          [_key(2000, bytes: 30), _cut(2500, bytes: 10)],
        ],
        [_tapAt(500), _tapAt(1500), _tapAt(2600)],
        nowMs: 3000,
        maxChunkBytes: 100,
      );

      expect(chunks.map((c) => c.frames.map((f) => f.tMs).toList()), [
        [0],
        [1000, 2000, 2500],
      ]);
      expect(chunks.every((c) => c.frames.first.keyframe), isTrue);
      expect(chunks.every((c) => c.byteSize <= 100), isTrue);
      expect(chunks.map((c) => (c.startMs, c.endMs)), [
        (0, 1000),
        (1000, 3000),
      ]);
      expect(chunks[0].marks.map((m) => m.tMs), [500]);
      expect(chunks[1].marks.map((m) => m.tMs), [1500, 2600]);
      expect(chunks.map((c) => (c.index, c.count)), [(0, 2), (1, 2)]);
    });

    test('beyond three chunks the oldest are left out', () {
      final chunks = splitLotseReplay(
        [
          for (var i = 0; i < 5; i++) [_key(i * 1000, bytes: 100)],
        ],
        const [],
        nowMs: 5000,
        maxChunkBytes: 100,
      );

      expect(chunks, hasLength(lotseReplayMaxChunks));
      expect(chunks.first.frames.single.tMs, 0, reason: 'from 2000 on');
      expect(chunks.last.endMs, 3000);
    });

    test('a new frame size starts a new chunk', () {
      final chunks = splitLotseReplay(
        [
          [_key(0)],
          [_key(1000, w: 800, h: 400)],
        ],
        const [],
        nowMs: 2000,
      );

      expect(chunks.map((c) => (c.width, c.height)), [(400, 800), (800, 400)]);
    });
  });

  group('thinLotseSegment', () {
    const small = (x: 0, y: 0, w: 16, h: 16);
    const large = (x: 0, y: 0, w: 32, h: 32);
    const elsewhere = (x: 100, y: 100, w: 16, h: 16);

    test('a segment within the limit stays as it is', () {
      final segment = [_key(0), _cut(1)];
      expect(thinLotseSegment(segment, 1000), segment);
    });

    test('cut-outs covered by a later one go first, the keyframe stays', () {
      final segment = [
        _key(0, bytes: 50),
        _cut(1, rect: small),
        _cut(2, rect: elsewhere),
        _cut(3, rect: small),
        _cut(4, rect: large),
      ];

      final thinned = thinLotseSegment(segment, 80);

      expect(thinned.first.keyframe, isTrue);
      expect(thinned.map((f) => f.tMs), containsAll([0, 2, 4]));
      expect(thinned.length, lessThan(segment.length));
      expect(lotseFramesBytes(thinned), lessThanOrEqualTo(80));
    });

    test('when nothing is covered the latest cut-outs go', () {
      final segment = [
        _key(0, bytes: 50),
        _cut(1, rect: small),
        _cut(2, rect: elsewhere),
      ];

      expect(thinLotseSegment(segment, 60).map((f) => f.tMs), [0, 1]);
      expect(thinLotseSegment(segment, 10).map((f) => f.tMs), [0]);
    });
  });
}

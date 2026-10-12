import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_replay_diff.dart';

/// A white RGBA frame of [w] × [h].
Uint8List _frame(int w, int h) =>
    Uint8List.fromList(List.filled(w * h * 4, 0xFF));

/// [frame] with the pixel at [x], [y] turned black.
Uint8List _dot(Uint8List frame, int w, int x, int y) {
  final copy = Uint8List.fromList(frame);
  final i = (y * w + x) * 4;
  copy.setRange(i, i + 3, [0, 0, 0]);
  return copy;
}

LotseReplayDiff _diff(Uint8List? a, Uint8List b, int w, int h) =>
    diffLotseFrames(
      a,
      b,
      width: w,
      height: h,
      previousWidth: w,
      previousHeight: h,
    );

void main() {
  const w = 100, h = 200;
  final white = _frame(w, h);

  test('the first frame is a keyframe of the whole frame', () {
    final d = diffLotseFrames(null, white, width: w, height: h);
    expect(d.keyframe, isTrue);
    expect(d.rects, [(x: 0, y: 0, w: w, h: h)]);
  });

  test('a frame of another size is a keyframe', () {
    final d = diffLotseFrames(
      _frame(50, 50),
      white,
      width: w,
      height: h,
      previousWidth: 50,
      previousHeight: 50,
    );
    expect(d.keyframe, isTrue);
  });

  test('an unchanged frame has no rects', () {
    final d = _diff(white, Uint8List.fromList(white), w, h);
    expect(d.keyframe, isFalse);
    expect(d.rects, isEmpty);
  });

  test('one changed pixel is the block around it', () {
    final d = _diff(white, _dot(white, w, 40, 70), w, h);
    expect(d.keyframe, isFalse);
    expect(d.rects, [(x: 32, y: 64, w: 16, h: 16)]);
  });

  test('a block at the edge is cut to the frame', () {
    // 100 is not a multiple of 16: the last column is 4 px wide.
    final d = _diff(white, _dot(white, w, 99, 199), w, h);
    expect(d.rects, [(x: 96, y: 192, w: 4, h: 8)]);
  });

  test('touching blocks become one rect, distant ones stay apart', () {
    var next = _dot(white, w, 15, 15);
    next = _dot(next, w, 16, 15);
    next = _dot(next, w, 90, 190);
    final rects = _diff(white, next, w, h).rects;
    expect(rects, hasLength(2));
    expect(rects, contains((x: 0, y: 0, w: 32, h: 16)));
    expect(rects, contains((x: 80, y: 176, w: 16, h: 16)));
  });

  test('many scattered changes are merged into at most four rects that '
      'cover all of them', () {
    var next = white;
    final dots = [
      for (var i = 0; i < 9; i++) (x: (i * 37) % w, y: (i * 53) % h),
    ];
    for (final d in dots) {
      next = _dot(next, w, d.x, d.y);
    }
    final rects = _diff(white, next, w, h).rects;
    expect(rects.length, lessThanOrEqualTo(lotseReplayMaxRects));
    for (final d in dots) {
      expect(
        rects.any(
          (r) => r.x <= d.x && d.x < r.x + r.w && r.y <= d.y && d.y < r.y + r.h,
        ),
        isTrue,
        reason: 'dot at $d',
      );
    }
  });

  test('more than half of the area changed is a keyframe', () {
    final next = Uint8List.fromList(white);
    next.fillRange(0, (w * h * 4 * 0.6).floor(), 0);
    final d = _diff(white, next, w, h);
    expect(d.keyframe, isTrue);
    expect(d.rects, [(x: 0, y: 0, w: w, h: h)]);
  });

  test('frames that do not start on a word boundary compare the same', () {
    final shifted = Uint8List(w * h * 4 + 1)..setRange(1, w * h * 4 + 1, white);
    final view = Uint8List.sublistView(shifted, 1);
    final d = _diff(view, _dot(white, w, 40, 70), w, h);
    expect(d.rects, [(x: 32, y: 64, w: 16, h: 16)]);
  });

  test('a crop takes the rows of the rect', () {
    final frame = Uint8List.fromList([
      for (var i = 0; i < 4 * 3; i++) ...[i, i, i, 255],
    ]);
    final crop = cropLotseFrame(frame, 4, (x: 1, y: 1, w: 2, h: 2));
    expect([for (var i = 0; i < crop.length; i += 4) crop[i]], [5, 6, 9, 10]);
    expect(cropLotseFrame(frame, 4, (x: 0, y: 0, w: 4, h: 3)), frame);
  });
}

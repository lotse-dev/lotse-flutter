import 'dart:math' as math;
import 'dart:typed_data';

// Comparing two masked frames of the replay, see `docs/REPLAY.md`,
// "Differenzen und Ringpuffer". Pure functions on raw RGBA pixels, so they
// run in an isolate on Android and on the main thread in the browser.

/// Edge of a comparison block in pixels.
const lotseReplayBlock = 16;

/// Changed regions of one frame are merged into at most this many rects.
const lotseReplayMaxRects = 4;

/// Above this share of changed pixels a frame becomes a keyframe.
const lotseReplayKeyframeShare = 0.5;

/// A rectangle in pixels of the frame.
typedef LotseReplayRect = ({int x, int y, int w, int h});

/// What changed from one frame to the next: the whole frame, or up to
/// [lotseReplayMaxRects] rects. No rects and no keyframe: nothing changed.
typedef LotseReplayDiff = ({bool keyframe, List<LotseReplayRect> rects});

/// Compares [next] with [previous], both RGBA of [width] × [height]. A
/// keyframe when there is no previous frame of that size or more than
/// [lotseReplayKeyframeShare] of the area changed.
LotseReplayDiff diffLotseFrames(
  Uint8List? previous,
  Uint8List next, {
  required int width,
  required int height,
  int? previousWidth,
  int? previousHeight,
}) {
  final whole = (x: 0, y: 0, w: width, h: height);
  if (previous == null ||
      previousWidth != width ||
      previousHeight != height ||
      previous.lengthInBytes != next.lengthInBytes) {
    return (keyframe: true, rects: [whole]);
  }
  final blocks = changedLotseBlocks(previous, next, width, height);
  if (blocks.isEmpty) return (keyframe: false, rects: const []);
  final rects = mergeLotseBlocks(
    blocks,
    columns: (width + lotseReplayBlock - 1) ~/ lotseReplayBlock,
    width: width,
    height: height,
  );
  final area = rects.fold(0, (sum, r) => sum + r.w * r.h);
  if (area > width * height * lotseReplayKeyframeShare) {
    return (keyframe: true, rects: [whole]);
  }
  return (keyframe: false, rects: rects);
}

/// Indices (row × columns + column) of the [lotseReplayBlock] blocks in
/// which [a] and [b] differ, in row order. Compared as 32-bit words, one
/// pixel each.
List<int> changedLotseBlocks(Uint8List a, Uint8List b, int width, int height) {
  final pa = _words(a, width * height);
  final pb = _words(b, width * height);
  const s = lotseReplayBlock;
  final columns = (width + s - 1) ~/ s;
  final rows = (height + s - 1) ~/ s;
  final changed = <int>[];
  for (var row = 0; row < rows; row++) {
    final y0 = row * s;
    final y1 = math.min(y0 + s, height);
    for (var column = 0; column < columns; column++) {
      final x0 = column * s;
      final x1 = math.min(x0 + s, width);
      var differs = false;
      for (var y = y0; y < y1 && !differs; y++) {
        final line = y * width;
        for (var x = x0; x < x1; x++) {
          if (pa[line + x] != pb[line + x]) {
            differs = true;
            break;
          }
        }
      }
      if (differs) changed.add(row * columns + column);
    }
  }
  return changed;
}

/// [bytes] as one 32-bit word per pixel; copied when not aligned.
Uint32List _words(Uint8List bytes, int length) => bytes.offsetInBytes % 4 == 0
    ? bytes.buffer.asUint32List(bytes.offsetInBytes, length)
    : Uint8List.fromList(bytes).buffer.asUint32List(0, length);

/// Merges changed [blocks] into at most [maxRects] rects in pixels: first
/// the bounding boxes of touching blocks, then the two boxes whose union
/// grows the area least, until few enough are left. Rects are cut to the
/// frame.
List<LotseReplayRect> mergeLotseBlocks(
  List<int> blocks, {
  required int columns,
  required int width,
  required int height,
  int maxRects = lotseReplayMaxRects,
}) {
  if (blocks.isEmpty) return const [];
  // Union-find over the blocks, joined with their left and upper neighbour.
  final index = {for (final (i, b) in blocks.indexed) b: i};
  final parent = List<int>.generate(blocks.length, (i) => i);
  int find(int i) {
    while (parent[i] != i) {
      parent[i] = parent[parent[i]];
      i = parent[i];
    }
    return i;
  }

  for (final (i, b) in blocks.indexed) {
    final column = b % columns;
    final left = column > 0 ? index[b - 1] : null;
    final up = index[b - columns];
    for (final j in [left, up]) {
      if (j != null) parent[find(i)] = find(j);
    }
  }
  final boxes = <int, _Box>{};
  for (final (i, b) in blocks.indexed) {
    final column = b % columns;
    final row = b ~/ columns;
    boxes.update(
      find(i),
      (box) => box.add(column, row),
      ifAbsent: () => _Box(column, row, column, row),
    );
  }
  var list = boxes.values.toList();
  // Many scattered changes: one box around all of them is as good and
  // keeps the merging below cheap.
  if (list.length > 64) list = [list.reduce((a, b) => a.union(b))];
  while (list.length > maxRects) {
    var best = (0, 1);
    var bestGrowth = 1 << 62;
    for (var i = 0; i < list.length; i++) {
      for (var j = i + 1; j < list.length; j++) {
        final growth =
            list[i].union(list[j]).area - list[i].area - list[j].area;
        if (growth < bestGrowth) {
          bestGrowth = growth;
          best = (i, j);
        }
      }
    }
    final (i, j) = best;
    final merged = list[i].union(list[j]);
    list = [
      for (final (k, box) in list.indexed)
        if (k != i && k != j) box,
      merged,
    ];
  }
  const s = lotseReplayBlock;
  return [
    for (final box in list)
      (
        x: box.left * s,
        y: box.top * s,
        w: math.min((box.right + 1) * s, width) - box.left * s,
        h: math.min((box.bottom + 1) * s, height) - box.top * s,
      ),
  ];
}

/// The pixels of [rect] from [rgba], a frame [width] pixels wide.
Uint8List cropLotseFrame(Uint8List rgba, int width, LotseReplayRect rect) {
  if (rect.x == 0 && rect.w == width && rect.y == 0) {
    return Uint8List.sublistView(rgba, 0, rect.w * rect.h * 4);
  }
  final out = Uint8List(rect.w * rect.h * 4);
  for (var row = 0; row < rect.h; row++) {
    final from = ((rect.y + row) * width + rect.x) * 4;
    out.setRange(row * rect.w * 4, (row + 1) * rect.w * 4, rgba, from);
  }
  return out;
}

/// A box of blocks, inclusive.
class _Box {
  _Box(this.left, this.top, this.right, this.bottom);

  final int left;
  final int top;
  final int right;
  final int bottom;

  int get area => (right - left + 1) * (bottom - top + 1);

  _Box add(int column, int row) => _Box(
    math.min(left, column),
    math.min(top, row),
    math.max(right, column),
    math.max(bottom, row),
  );

  _Box union(_Box o) => _Box(
    math.min(left, o.left),
    math.min(top, o.top),
    math.max(right, o.right),
    math.max(bottom, o.bottom),
  );
}

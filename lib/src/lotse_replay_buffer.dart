import 'dart:math' as math;
import 'dart:typed_data';

import 'lotse_replay_diff.dart';

// The ring buffer of the replay and its split into upload chunks, see
// `docs/REPLAY.md`, "Differenzen und Ringpuffer" and "Grenzen". Pure Dart.
//
// Frames come in segments: a keyframe and the cut-outs after it. A segment
// is only ever dropped whole, so what is left always starts with a keyframe
// and can be played.

/// Bytes the buffer holds at most, PNGs counted.
const lotseReplayMaxBufferBytes = 4 * 1024 * 1024;

/// Bytes of one uploaded chunk at most; about 1.4 MB as Base64, under the
/// 2 MB request limit of the server.
const lotseReplayMaxChunkBytes = 1024 * 1024;

/// Chunks of one replay at most, the newest kept.
const lotseReplayMaxChunks = 3;

/// One encoded picture of the replay: the whole frame for a keyframe, a
/// changed region otherwise. [tMs] counts from the start of the recorder.
class LotseReplayFrame {
  const LotseReplayFrame({
    required this.tMs,
    required this.rect,
    required this.png,
    required this.keyframe,
    required this.width,
    required this.height,
  });

  final int tMs;

  /// Where [png] goes, in pixels of the frame.
  final LotseReplayRect rect;
  final Uint8List png;
  final bool keyframe;

  /// Size of the whole frame.
  final int width;
  final int height;

  LotseReplayFrame at(int tMs) => LotseReplayFrame(
    tMs: tMs,
    rect: rect,
    png: png,
    keyframe: keyframe,
    width: width,
    height: height,
  );
}

enum LotseReplayMarkKind { tap, screen, pause, resume }

/// Something that happened beside the picture: a tap, a new screen, the app
/// leaving or coming back.
class LotseReplayMark {
  const LotseReplayMark({
    required this.tMs,
    required this.kind,
    this.x,
    this.y,
    this.screen,
  });

  final int tMs;
  final LotseReplayMarkKind kind;

  /// Of a tap, in pixels of the frame.
  final int? x;
  final int? y;

  /// Of a screen mark.
  final String? screen;

  LotseReplayMark at(int tMs) =>
      LotseReplayMark(tMs: tMs, kind: kind, x: x, y: y, screen: screen);
}

/// One upload: starts with a keyframe and plays on its own. Times count from
/// the start of the first chunk.
class LotseReplayChunk {
  const LotseReplayChunk({
    required this.index,
    required this.count,
    required this.startMs,
    required this.endMs,
    required this.width,
    required this.height,
    required this.frames,
    required this.marks,
    this.endedAt,
  });

  final int index;
  final int count;
  final int startMs;
  final int endMs;
  final int width;
  final int height;
  final List<LotseReplayFrame> frames;
  final List<LotseReplayMark> marks;

  /// Wall clock in UTC when the replay was cut, the moment the end of the
  /// last chunk stands for. The clock of the events, so the console places
  /// them on the timeline without the upload in between.
  final DateTime? endedAt;

  int get byteSize => lotseFramesBytes(frames);

  /// This chunk with [endedAt].
  LotseReplayChunk endingAt(DateTime endedAt) => LotseReplayChunk(
    index: index,
    count: count,
    startMs: startMs,
    endMs: endMs,
    width: width,
    height: height,
    frames: frames,
    marks: marks,
    endedAt: endedAt,
  );
}

int lotseFramesBytes(Iterable<LotseReplayFrame> frames) =>
    frames.fold(0, (sum, f) => sum + f.png.lengthInBytes);

/// The last [windowMs] of frames and marks, at most [maxBytes].
class LotseReplayBuffer {
  LotseReplayBuffer({
    required this.windowMs,
    this.maxBytes = lotseReplayMaxBufferBytes,
  });

  final int windowMs;
  final int maxBytes;
  final _segments = <List<LotseReplayFrame>>[];
  final _marks = <LotseReplayMark>[];
  var _bytes = 0;

  int get byteSize => _bytes;
  bool get isEmpty => _segments.isEmpty;

  /// Time of the first frame held, or null.
  int? get startMs => _segments.firstOrNull?.first.tMs;

  List<LotseReplayFrame> get frames => [for (final s in _segments) ...s];
  List<LotseReplayMark> get marks => List.unmodifiable(_marks);

  /// Adds [frame]. A keyframe opens a segment; a cut-out without a keyframe
  /// before it is dropped, it could not be played.
  void add(LotseReplayFrame frame) {
    if (frame.keyframe) {
      _segments.add([frame]);
    } else if (_segments.isNotEmpty) {
      _segments.last.add(frame);
    } else {
      return;
    }
    _bytes += frame.png.lengthInBytes;
  }

  void addMark(LotseReplayMark mark) => _marks.add(mark);

  /// Drops whole segments from the front while the next one still begins
  /// inside the window before [nowMs], or while the buffer is over
  /// [maxBytes]. The newest segment always stays. Marks before the first
  /// frame go too, see [lotseMarksFrom].
  void trim(int nowMs) {
    final windowStart = nowMs - windowMs;
    while (_segments.length > 1 &&
        (_segments[1].first.tMs <= windowStart || _bytes > maxBytes)) {
      _bytes -= lotseFramesBytes(_segments.removeAt(0));
    }
    final kept = lotseMarksFrom(_marks, startMs ?? nowMs);
    _marks
      ..clear()
      ..addAll(kept);
  }

  void clear() {
    _segments.clear();
    _marks.clear();
    _bytes = 0;
  }

  /// The last [windowMs] before [nowMs] as upload chunks, see
  /// [splitLotseReplay]. The oldest segment kept may begin long before the
  /// window, after a still screen: what it shows at the window start, its
  /// keyframe and the cut-outs until then, moves to the window start.
  List<LotseReplayChunk> chunks(int nowMs) {
    trim(nowMs);
    final windowStart = nowMs - windowMs;
    final first = _segments.firstOrNull;
    if (first == null || first.first.tMs >= windowStart) {
      return splitLotseReplay(_segments, _marks, nowMs: nowMs);
    }
    return splitLotseReplay(
      [
        [for (final f in first) f.tMs < windowStart ? f.at(windowStart) : f],
        ..._segments.skip(1),
      ],
      lotseMarksFrom(_marks, windowStart),
      nowMs: nowMs,
    );
  }
}

/// [marks] from [startMs] on. The last screen mark before moves to
/// [startMs]: it names the screen the replay begins on.
List<LotseReplayMark> lotseMarksFrom(List<LotseReplayMark> marks, int startMs) {
  final screen = marks
      .where((m) => m.tMs < startMs && m.kind == LotseReplayMarkKind.screen)
      .lastOrNull;
  return [?screen?.at(startMs), ...marks.where((m) => m.tMs >= startMs)];
}

/// Splits [segments] into chunks of at most [maxChunkBytes], each starting
/// with a keyframe and of one frame size, the newest [maxChunks] of them.
/// A segment too large for a chunk is thinned, see [thinLotseSegment]. Times
/// are made relative to the first frame kept; the last chunk ends at
/// [nowMs].
List<LotseReplayChunk> splitLotseReplay(
  List<List<LotseReplayFrame>> segments,
  List<LotseReplayMark> marks, {
  required int nowMs,
  int maxChunkBytes = lotseReplayMaxChunkBytes,
  int maxChunks = lotseReplayMaxChunks,
}) {
  // From the newest backwards: the end of the window is what the report is
  // about.
  final groups = <List<List<LotseReplayFrame>>>[];
  var group = <List<LotseReplayFrame>>[];
  var groupBytes = 0;
  for (final raw in segments.reversed) {
    final segment = thinLotseSegment(raw, maxChunkBytes);
    final bytes = lotseFramesBytes(segment);
    final fits =
        group.isEmpty ||
        (groupBytes + bytes <= maxChunkBytes &&
            group.first.first.width == segment.first.width &&
            group.first.first.height == segment.first.height);
    if (!fits) {
      groups.add(group);
      if (groups.length == maxChunks) {
        group = [];
        break;
      }
      group = [];
      groupBytes = 0;
    }
    group.insert(0, segment);
    groupBytes += bytes;
  }
  if (group.isNotEmpty) groups.add(group);
  if (groups.isEmpty) return const [];

  final ordered = groups.reversed.toList();
  final base = ordered.first.first.first.tMs;
  final starts = [for (final g in ordered) g.first.first.tMs];
  return [
    for (final (i, g) in ordered.indexed)
      () {
        final frames = [
          for (final s in g)
            for (final f in s) f.at(f.tMs - base),
        ];
        final end = i + 1 < ordered.length ? starts[i + 1] : nowMs;
        return LotseReplayChunk(
          index: i,
          count: ordered.length,
          startMs: starts[i] - base,
          endMs: math.max(end - base, frames.last.tMs),
          width: frames.first.width,
          height: frames.first.height,
          frames: frames,
          marks: [
            for (final m in marks)
              if (m.tMs >= starts[i] && m.tMs < end ||
                  (i + 1 == ordered.length && m.tMs == end))
                m.at(m.tMs - base),
          ],
        );
      }(),
  ];
}

/// [segment] cut down to [maxBytes]. First, cut-outs that a later cut-out
/// covers completely are dropped, every other one per pass: the region
/// shows older pixels for a moment, never wrong ones. If that is not
/// enough, the latest cut-outs go; the keyframe always stays.
List<LotseReplayFrame> thinLotseSegment(
  List<LotseReplayFrame> segment,
  int maxBytes,
) {
  var frames = List.of(segment);
  var bytes = lotseFramesBytes(frames);
  while (bytes > maxBytes) {
    final covered = <int>[
      for (var i = 1; i < frames.length - 1; i++)
        if (_coveredLater(frames, i)) i,
    ];
    if (covered.isEmpty) break;
    final drop = {for (var k = 0; k < covered.length; k += 2) covered[k]};
    frames = [
      for (final (i, f) in frames.indexed)
        if (!drop.contains(i)) f,
    ];
    bytes = lotseFramesBytes(frames);
  }
  while (bytes > maxBytes && frames.length > 1) {
    bytes -= frames.removeLast().png.lengthInBytes;
  }
  return frames;
}

bool _coveredLater(List<LotseReplayFrame> frames, int i) {
  final r = frames[i].rect;
  for (var j = i + 1; j < frames.length; j++) {
    final o = frames[j].rect;
    if (o.x <= r.x &&
        o.y <= r.y &&
        o.x + o.w >= r.x + r.w &&
        o.y + o.h >= r.y + r.h) {
      return true;
    }
  }
  return false;
}

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

import 'lotse_replay_buffer.dart';

/// Sends one chunk of the replay of feedback [feedbackId].
typedef LotseReplayChunkCall =
    Future<void> Function(int feedbackId, generated.ReplayChunk chunk);

/// Sends [chunks] for the feedback message [feedbackId], the newest first:
/// when the upload breaks off, what led up to the message is on the server
/// already. Stops at the first failure. Returns how many chunks arrived.
/// Never throws; the message is sent either way.
Future<int> uploadLotseReplay(
  LotseReplayChunkCall send,
  int feedbackId,
  List<LotseReplayChunk> chunks,
) async {
  var sent = 0;
  for (final chunk in chunks.reversed) {
    try {
      await send(feedbackId, generatedReplayChunk(chunk));
      sent++;
    } catch (error) {
      debugPrint(
        'Lotse: replay chunk ${chunk.index + 1} of ${chunk.count} not sent: '
        '${error.runtimeType}',
      );
      break;
    }
  }
  return sent;
}

/// [chunk] as the server takes it. The generated types never leave the SDK.
generated.ReplayChunk generatedReplayChunk(LotseReplayChunk chunk) =>
    generated.ReplayChunk(
      index: chunk.index,
      count: chunk.count,
      startMs: chunk.startMs,
      endMs: chunk.endMs,
      width: chunk.width,
      height: chunk.height,
      endedAt: chunk.endedAt,
      frames: [
        for (final f in chunk.frames)
          generated.ReplayFrame(
            tMs: f.tMs,
            x: f.rect.x,
            y: f.rect.y,
            w: f.rect.w,
            h: f.rect.h,
            png: ByteData.sublistView(f.png),
          ),
      ],
      marks: [
        for (final m in chunk.marks)
          generated.ReplayMark(
            tMs: m.tMs,
            kind: switch (m.kind) {
              LotseReplayMarkKind.tap => generated.ReplayMarkKind.tap,
              LotseReplayMarkKind.screen => generated.ReplayMarkKind.screen,
              LotseReplayMarkKind.pause => generated.ReplayMarkKind.pause,
              LotseReplayMarkKind.resume => generated.ReplayMarkKind.resume,
            },
            x: m.x,
            y: m.y,
            screen: m.screen,
          ),
      ],
    );

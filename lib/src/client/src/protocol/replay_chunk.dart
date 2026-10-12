/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:lotse/src/client/src/protocol/protocol.dart' as _ist2d7e6;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'replay_frame.dart' as _i5dutshk;
import 'replay_mark.dart' as _i4x1uj01;

/// One chunk of a feedback replay on the wire, see
/// `SdkEndpoint.submitFeedbackReplayChunk`. It starts with a keyframe and
/// plays on its own. Times count from the start of the first chunk.
abstract class ReplayChunk
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReplayChunk._({
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

  factory ReplayChunk({
    required int index,
    required int count,
    required int startMs,
    required int endMs,
    required int width,
    required int height,
    required List<_i5dutshk.ReplayFrame> frames,
    required List<_i4x1uj01.ReplayMark> marks,
    DateTime? endedAt,
  }) = _ReplayChunkImpl;

  factory ReplayChunk.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplayChunk(
      index: jsonSerialization['index'] as int,
      count: jsonSerialization['count'] as int,
      startMs: jsonSerialization['startMs'] as int,
      endMs: jsonSerialization['endMs'] as int,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      frames: _ist2d7e6.Protocol().deserialize<List<_i5dutshk.ReplayFrame>>(
        jsonSerialization['frames'],
      ),
      marks: _ist2d7e6.Protocol().deserialize<List<_i4x1uj01.ReplayMark>>(
        jsonSerialization['marks'],
      ),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
    );
  }

  int index;

  int count;

  int startMs;

  int endMs;

  /// Pixels of the whole frame.
  int width;

  int height;

  List<_i5dutshk.ReplayFrame> frames;

  List<_i4x1uj01.ReplayMark> marks;

  /// Device clock when the SDK cut the replay, the moment the end of the
  /// last chunk stands for. The clock of the event timestamps, so the
  /// console places events without the server's clock and the upload in
  /// between. Null from SDKs before 28 September 2026.
  DateTime? endedAt;

  /// Returns a shallow copy of this [ReplayChunk]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReplayChunk copyWith({
    int? index,
    int? count,
    int? startMs,
    int? endMs,
    int? width,
    int? height,
    List<_i5dutshk.ReplayFrame>? frames,
    List<_i4x1uj01.ReplayMark>? marks,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplayChunk',
      'index': index,
      'count': count,
      'startMs': startMs,
      'endMs': endMs,
      'width': width,
      'height': height,
      'frames': frames.toJson(valueToJson: (v) => v.toJson()),
      'marks': marks.toJson(valueToJson: (v) => v.toJson()),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplayChunk',
      'index': index,
      'count': count,
      'startMs': startMs,
      'endMs': endMs,
      'width': width,
      'height': height,
      'frames': frames.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'marks': marks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReplayChunkImpl extends ReplayChunk {
  _ReplayChunkImpl({
    required int index,
    required int count,
    required int startMs,
    required int endMs,
    required int width,
    required int height,
    required List<_i5dutshk.ReplayFrame> frames,
    required List<_i4x1uj01.ReplayMark> marks,
    DateTime? endedAt,
  }) : super._(
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

  /// Returns a shallow copy of this [ReplayChunk]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReplayChunk copyWith({
    int? index,
    int? count,
    int? startMs,
    int? endMs,
    int? width,
    int? height,
    List<_i5dutshk.ReplayFrame>? frames,
    List<_i4x1uj01.ReplayMark>? marks,
    Object? endedAt = _Undefined,
  }) {
    return ReplayChunk(
      index: index ?? this.index,
      count: count ?? this.count,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      width: width ?? this.width,
      height: height ?? this.height,
      frames: frames ?? this.frames.map((e0) => e0.copyWith()).toList(),
      marks: marks ?? this.marks.map((e0) => e0.copyWith()).toList(),
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}

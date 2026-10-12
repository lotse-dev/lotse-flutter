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

/// What the console knows of a feedback replay before loading its chunks.
abstract class FeedbackReplayInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackReplayInfo._({
    required this.width,
    required this.height,
    required this.durationMs,
    required this.chunkCount,
    required this.chunks,
    required this.byteSize,
    this.endedAt,
    required this.createdAt,
    this.completedAt,
  });

  factory FeedbackReplayInfo({
    required int width,
    required int height,
    required int durationMs,
    required int chunkCount,
    required List<int> chunks,
    required int byteSize,
    DateTime? endedAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _FeedbackReplayInfoImpl;

  factory FeedbackReplayInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackReplayInfo(
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      durationMs: jsonSerialization['durationMs'] as int,
      chunkCount: jsonSerialization['chunkCount'] as int,
      chunks: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['chunks'],
      ),
      byteSize: jsonSerialization['byteSize'] as int,
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  int width;

  int height;

  int durationMs;

  int chunkCount;

  /// Indices of the chunks that arrived, ascending. Fewer than chunkCount
  /// when the upload broke off; each chunk plays on its own.
  List<int> chunks;

  int byteSize;

  /// Device clock at the end of the replay; null for older SDKs. The
  /// console then counts back from the arrival of the message.
  DateTime? endedAt;

  DateTime createdAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [FeedbackReplayInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackReplayInfo copyWith({
    int? width,
    int? height,
    int? durationMs,
    int? chunkCount,
    List<int>? chunks,
    int? byteSize,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackReplayInfo',
      'width': width,
      'height': height,
      'durationMs': durationMs,
      'chunkCount': chunkCount,
      'chunks': chunks.toJson(),
      'byteSize': byteSize,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackReplayInfo',
      'width': width,
      'height': height,
      'durationMs': durationMs,
      'chunkCount': chunkCount,
      'chunks': chunks.toJson(),
      'byteSize': byteSize,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackReplayInfoImpl extends FeedbackReplayInfo {
  _FeedbackReplayInfoImpl({
    required int width,
    required int height,
    required int durationMs,
    required int chunkCount,
    required List<int> chunks,
    required int byteSize,
    DateTime? endedAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
         width: width,
         height: height,
         durationMs: durationMs,
         chunkCount: chunkCount,
         chunks: chunks,
         byteSize: byteSize,
         endedAt: endedAt,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [FeedbackReplayInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackReplayInfo copyWith({
    int? width,
    int? height,
    int? durationMs,
    int? chunkCount,
    List<int>? chunks,
    int? byteSize,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return FeedbackReplayInfo(
      width: width ?? this.width,
      height: height ?? this.height,
      durationMs: durationMs ?? this.durationMs,
      chunkCount: chunkCount ?? this.chunkCount,
      chunks: chunks ?? this.chunks.map((e0) => e0).toList(),
      byteSize: byteSize ?? this.byteSize,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}

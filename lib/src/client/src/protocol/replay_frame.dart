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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// One PNG of a replay chunk at tMs from the start of the replay, to be
/// drawn at x, y with size w × h over what came before. The first frame of
/// a chunk covers the whole frame.
abstract class ReplayFrame
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReplayFrame._({
    required this.tMs,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.png,
  });

  factory ReplayFrame({
    required int tMs,
    required int x,
    required int y,
    required int w,
    required int h,
    required _idt.ByteData png,
  }) = _ReplayFrameImpl;

  factory ReplayFrame.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplayFrame(
      tMs: jsonSerialization['tMs'] as int,
      x: jsonSerialization['x'] as int,
      y: jsonSerialization['y'] as int,
      w: jsonSerialization['w'] as int,
      h: jsonSerialization['h'] as int,
      png: _isc.ByteDataJsonExtension.fromJson(jsonSerialization['png']),
    );
  }

  int tMs;

  int x;

  int y;

  int w;

  int h;

  _idt.ByteData png;

  /// Returns a shallow copy of this [ReplayFrame]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReplayFrame copyWith({
    int? tMs,
    int? x,
    int? y,
    int? w,
    int? h,
    _idt.ByteData? png,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplayFrame',
      'tMs': tMs,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'png': png.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplayFrame',
      'tMs': tMs,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'png': png.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReplayFrameImpl extends ReplayFrame {
  _ReplayFrameImpl({
    required int tMs,
    required int x,
    required int y,
    required int w,
    required int h,
    required _idt.ByteData png,
  }) : super._(
         tMs: tMs,
         x: x,
         y: y,
         w: w,
         h: h,
         png: png,
       );

  /// Returns a shallow copy of this [ReplayFrame]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReplayFrame copyWith({
    int? tMs,
    int? x,
    int? y,
    int? w,
    int? h,
    _idt.ByteData? png,
  }) {
    return ReplayFrame(
      tMs: tMs ?? this.tMs,
      x: x ?? this.x,
      y: y ?? this.y,
      w: w ?? this.w,
      h: h ?? this.h,
      png: png ?? this.png.clone(),
    );
  }
}

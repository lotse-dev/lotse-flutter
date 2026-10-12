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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'replay_mark_kind.dart' as _igbo9v0t;

/// Something beside the picture of a replay, at tMs from the start of the
/// replay: a tap (x, y in pixels of the frame), a new screen, the app
/// leaving or coming back.
abstract class ReplayMark
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReplayMark._({
    required this.tMs,
    required this.kind,
    this.x,
    this.y,
    this.screen,
  });

  factory ReplayMark({
    required int tMs,
    required _igbo9v0t.ReplayMarkKind kind,
    int? x,
    int? y,
    String? screen,
  }) = _ReplayMarkImpl;

  factory ReplayMark.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplayMark(
      tMs: jsonSerialization['tMs'] as int,
      kind: _igbo9v0t.ReplayMarkKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      x: jsonSerialization['x'] as int?,
      y: jsonSerialization['y'] as int?,
      screen: jsonSerialization['screen'] as String?,
    );
  }

  int tMs;

  _igbo9v0t.ReplayMarkKind kind;

  int? x;

  int? y;

  String? screen;

  /// Returns a shallow copy of this [ReplayMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReplayMark copyWith({
    int? tMs,
    _igbo9v0t.ReplayMarkKind? kind,
    int? x,
    int? y,
    String? screen,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplayMark',
      'tMs': tMs,
      'kind': kind.toJson(),
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (screen != null) 'screen': screen,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplayMark',
      'tMs': tMs,
      'kind': kind.toJson(),
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (screen != null) 'screen': screen,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReplayMarkImpl extends ReplayMark {
  _ReplayMarkImpl({
    required int tMs,
    required _igbo9v0t.ReplayMarkKind kind,
    int? x,
    int? y,
    String? screen,
  }) : super._(
         tMs: tMs,
         kind: kind,
         x: x,
         y: y,
         screen: screen,
       );

  /// Returns a shallow copy of this [ReplayMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReplayMark copyWith({
    int? tMs,
    _igbo9v0t.ReplayMarkKind? kind,
    Object? x = _Undefined,
    Object? y = _Undefined,
    Object? screen = _Undefined,
  }) {
    return ReplayMark(
      tMs: tMs ?? this.tMs,
      kind: kind ?? this.kind,
      x: x is int? ? x : this.x,
      y: y is int? ? y : this.y,
      screen: screen is String? ? screen : this.screen,
    );
  }
}

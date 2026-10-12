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

/// One tap as sent by the SDK, see `SdkEndpoint.submitTaps`.
abstract class TrackedTap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TrackedTap._({
    required this.screen,
    required this.ts,
    required this.x,
    required this.y,
    this.scrollY,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.rage,
  });

  factory TrackedTap({
    required String screen,
    required DateTime ts,
    required int x,
    required int y,
    int? scrollY,
    required int viewportWidth,
    required int viewportHeight,
    required bool rage,
  }) = _TrackedTapImpl;

  factory TrackedTap.fromJson(Map<String, dynamic> jsonSerialization) {
    return TrackedTap(
      screen: jsonSerialization['screen'] as String,
      ts: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
      x: jsonSerialization['x'] as int,
      y: jsonSerialization['y'] as int,
      scrollY: jsonSerialization['scrollY'] as int?,
      viewportWidth: jsonSerialization['viewportWidth'] as int,
      viewportHeight: jsonSerialization['viewportHeight'] as int,
      rage: _isc.BoolJsonExtension.fromJson(jsonSerialization['rage']),
    );
  }

  /// Top named page from LotseScreenObserver.
  String screen;

  DateTime ts;

  /// Logical pixels inside the LotseScope boundary.
  int x;

  int y;

  /// Offset of the innermost vertical scroll view under the tap, read on
  /// pointer down. Null when the tap was outside of one.
  int? scrollY;

  int viewportWidth;

  int viewportHeight;

  /// Set by the SDK on every tap of a rage burst: at least three taps within
  /// one second, each at most 30 logical pixels from the first.
  bool rage;

  /// Returns a shallow copy of this [TrackedTap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TrackedTap copyWith({
    String? screen,
    DateTime? ts,
    int? x,
    int? y,
    int? scrollY,
    int? viewportWidth,
    int? viewportHeight,
    bool? rage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TrackedTap',
      'screen': screen,
      'ts': ts.toJson(),
      'x': x,
      'y': y,
      if (scrollY != null) 'scrollY': scrollY,
      'viewportWidth': viewportWidth,
      'viewportHeight': viewportHeight,
      'rage': rage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TrackedTap',
      'screen': screen,
      'ts': ts.toJson(),
      'x': x,
      'y': y,
      if (scrollY != null) 'scrollY': scrollY,
      'viewportWidth': viewportWidth,
      'viewportHeight': viewportHeight,
      'rage': rage,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrackedTapImpl extends TrackedTap {
  _TrackedTapImpl({
    required String screen,
    required DateTime ts,
    required int x,
    required int y,
    int? scrollY,
    required int viewportWidth,
    required int viewportHeight,
    required bool rage,
  }) : super._(
         screen: screen,
         ts: ts,
         x: x,
         y: y,
         scrollY: scrollY,
         viewportWidth: viewportWidth,
         viewportHeight: viewportHeight,
         rage: rage,
       );

  /// Returns a shallow copy of this [TrackedTap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TrackedTap copyWith({
    String? screen,
    DateTime? ts,
    int? x,
    int? y,
    Object? scrollY = _Undefined,
    int? viewportWidth,
    int? viewportHeight,
    bool? rage,
  }) {
    return TrackedTap(
      screen: screen ?? this.screen,
      ts: ts ?? this.ts,
      x: x ?? this.x,
      y: y ?? this.y,
      scrollY: scrollY is int? ? scrollY : this.scrollY,
      viewportWidth: viewportWidth ?? this.viewportWidth,
      viewportHeight: viewportHeight ?? this.viewportHeight,
      rage: rage ?? this.rage,
    );
  }
}

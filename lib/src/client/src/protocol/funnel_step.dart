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

/// One step of a funnel: an event name and optionally one prop the event
/// must carry with exactly this value, e.g. screen_view with screen=product.
abstract class FunnelStep
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FunnelStep._({
    required this.name,
    this.propKey,
    this.propValue,
  });

  factory FunnelStep({
    required String name,
    String? propKey,
    String? propValue,
  }) = _FunnelStepImpl;

  factory FunnelStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return FunnelStep(
      name: jsonSerialization['name'] as String,
      propKey: jsonSerialization['propKey'] as String?,
      propValue: jsonSerialization['propValue'] as String?,
    );
  }

  String name;

  /// Set together with propValue, or neither.
  String? propKey;

  String? propValue;

  /// Returns a shallow copy of this [FunnelStep]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FunnelStep copyWith({
    String? name,
    String? propKey,
    String? propValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FunnelStep',
      'name': name,
      if (propKey != null) 'propKey': propKey,
      if (propValue != null) 'propValue': propValue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FunnelStep',
      'name': name,
      if (propKey != null) 'propKey': propKey,
      if (propValue != null) 'propValue': propValue,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FunnelStepImpl extends FunnelStep {
  _FunnelStepImpl({
    required String name,
    String? propKey,
    String? propValue,
  }) : super._(
         name: name,
         propKey: propKey,
         propValue: propValue,
       );

  /// Returns a shallow copy of this [FunnelStep]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FunnelStep copyWith({
    String? name,
    Object? propKey = _Undefined,
    Object? propValue = _Undefined,
  }) {
    return FunnelStep(
      name: name ?? this.name,
      propKey: propKey is String? ? propKey : this.propKey,
      propValue: propValue is String? ? propValue : this.propValue,
    );
  }
}

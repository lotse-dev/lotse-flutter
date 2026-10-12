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
import 'journey_trigger.dart' as _ia9frtih;
import 'journey_variant_input.dart' as _it0j7yj1;

/// What `ProjectEndpoint.createJourney` and `updateJourney` take. Checked by
/// `journeys/journey_input.dart`.
abstract class JourneyInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyInput._({
    required this.name,
    required this.trigger,
    this.triggerEvent,
    this.triggerPropKey,
    this.triggerPropValue,
    required this.delayMinutes,
    required this.goalEvent,
    required this.goalWindowHours,
    this.segment,
    required this.holdoutPercent,
    required this.autoWinner,
    required this.variants,
  });

  factory JourneyInput({
    required String name,
    required _ia9frtih.JourneyTrigger trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    required int delayMinutes,
    required String goalEvent,
    required int goalWindowHours,
    String? segment,
    required int holdoutPercent,
    required bool autoWinner,
    required List<_it0j7yj1.JourneyVariantInput> variants,
  }) = _JourneyInputImpl;

  factory JourneyInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyInput(
      name: jsonSerialization['name'] as String,
      trigger: _ia9frtih.JourneyTrigger.fromJson(
        (jsonSerialization['trigger'] as String),
      ),
      triggerEvent: jsonSerialization['triggerEvent'] as String?,
      triggerPropKey: jsonSerialization['triggerPropKey'] as String?,
      triggerPropValue: jsonSerialization['triggerPropValue'] as String?,
      delayMinutes: jsonSerialization['delayMinutes'] as int,
      goalEvent: jsonSerialization['goalEvent'] as String,
      goalWindowHours: jsonSerialization['goalWindowHours'] as int,
      segment: jsonSerialization['segment'] as String?,
      holdoutPercent: jsonSerialization['holdoutPercent'] as int,
      autoWinner: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['autoWinner'],
      ),
      variants: _ist2d7e6.Protocol()
          .deserialize<List<_it0j7yj1.JourneyVariantInput>>(
            jsonSerialization['variants'],
          ),
    );
  }

  String name;

  _ia9frtih.JourneyTrigger trigger;

  /// Required for the trigger `event`, refused for `install`.
  String? triggerEvent;

  String? triggerPropKey;

  String? triggerPropValue;

  int delayMinutes;

  String goalEvent;

  int goalWindowHours;

  /// Audience predicate as JSON text, like `createCampaign`; null or empty
  /// for every device.
  String? segment;

  int holdoutPercent;

  bool autoWinner;

  /// One or two: A, then B.
  List<_it0j7yj1.JourneyVariantInput> variants;

  /// Returns a shallow copy of this [JourneyInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyInput copyWith({
    String? name,
    _ia9frtih.JourneyTrigger? trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    int? delayMinutes,
    String? goalEvent,
    int? goalWindowHours,
    String? segment,
    int? holdoutPercent,
    bool? autoWinner,
    List<_it0j7yj1.JourneyVariantInput>? variants,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyInput',
      'name': name,
      'trigger': trigger.toJson(),
      if (triggerEvent != null) 'triggerEvent': triggerEvent,
      if (triggerPropKey != null) 'triggerPropKey': triggerPropKey,
      if (triggerPropValue != null) 'triggerPropValue': triggerPropValue,
      'delayMinutes': delayMinutes,
      'goalEvent': goalEvent,
      'goalWindowHours': goalWindowHours,
      if (segment != null) 'segment': segment,
      'holdoutPercent': holdoutPercent,
      'autoWinner': autoWinner,
      'variants': variants.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyInput',
      'name': name,
      'trigger': trigger.toJson(),
      if (triggerEvent != null) 'triggerEvent': triggerEvent,
      if (triggerPropKey != null) 'triggerPropKey': triggerPropKey,
      if (triggerPropValue != null) 'triggerPropValue': triggerPropValue,
      'delayMinutes': delayMinutes,
      'goalEvent': goalEvent,
      'goalWindowHours': goalWindowHours,
      if (segment != null) 'segment': segment,
      'holdoutPercent': holdoutPercent,
      'autoWinner': autoWinner,
      'variants': variants.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyInputImpl extends JourneyInput {
  _JourneyInputImpl({
    required String name,
    required _ia9frtih.JourneyTrigger trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    required int delayMinutes,
    required String goalEvent,
    required int goalWindowHours,
    String? segment,
    required int holdoutPercent,
    required bool autoWinner,
    required List<_it0j7yj1.JourneyVariantInput> variants,
  }) : super._(
         name: name,
         trigger: trigger,
         triggerEvent: triggerEvent,
         triggerPropKey: triggerPropKey,
         triggerPropValue: triggerPropValue,
         delayMinutes: delayMinutes,
         goalEvent: goalEvent,
         goalWindowHours: goalWindowHours,
         segment: segment,
         holdoutPercent: holdoutPercent,
         autoWinner: autoWinner,
         variants: variants,
       );

  /// Returns a shallow copy of this [JourneyInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyInput copyWith({
    String? name,
    _ia9frtih.JourneyTrigger? trigger,
    Object? triggerEvent = _Undefined,
    Object? triggerPropKey = _Undefined,
    Object? triggerPropValue = _Undefined,
    int? delayMinutes,
    String? goalEvent,
    int? goalWindowHours,
    Object? segment = _Undefined,
    int? holdoutPercent,
    bool? autoWinner,
    List<_it0j7yj1.JourneyVariantInput>? variants,
  }) {
    return JourneyInput(
      name: name ?? this.name,
      trigger: trigger ?? this.trigger,
      triggerEvent: triggerEvent is String? ? triggerEvent : this.triggerEvent,
      triggerPropKey: triggerPropKey is String?
          ? triggerPropKey
          : this.triggerPropKey,
      triggerPropValue: triggerPropValue is String?
          ? triggerPropValue
          : this.triggerPropValue,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      goalEvent: goalEvent ?? this.goalEvent,
      goalWindowHours: goalWindowHours ?? this.goalWindowHours,
      segment: segment is String? ? segment : this.segment,
      holdoutPercent: holdoutPercent ?? this.holdoutPercent,
      autoWinner: autoWinner ?? this.autoWinner,
      variants: variants ?? this.variants.map((e0) => e0.copyWith()).toList(),
    );
  }
}

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

/// One event as sent by the SDK.
abstract class TrackedEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TrackedEvent._({
    required this.name,
    required this.ts,
    this.sessionId,
    this.props,
    this.clientId,
  });

  factory TrackedEvent({
    required String name,
    required DateTime ts,
    String? sessionId,
    Map<String, String>? props,
    String? clientId,
  }) = _TrackedEventImpl;

  factory TrackedEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TrackedEvent(
      name: jsonSerialization['name'] as String,
      ts: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
      sessionId: jsonSerialization['sessionId'] as String?,
      props: jsonSerialization['props'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['props'],
            ),
      clientId: jsonSerialization['clientId'] as String?,
    );
  }

  String name;

  DateTime ts;

  String? sessionId;

  Map<String, String>? props;

  /// Id the SDK gives the event when it queues it, the same on every retry.
  /// The server stores an event of a device once per clientId. Null from SDKs
  /// before the offline queue, which never retried.
  String? clientId;

  /// Returns a shallow copy of this [TrackedEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TrackedEvent copyWith({
    String? name,
    DateTime? ts,
    String? sessionId,
    Map<String, String>? props,
    String? clientId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TrackedEvent',
      'name': name,
      'ts': ts.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      if (props != null) 'props': props?.toJson(),
      if (clientId != null) 'clientId': clientId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TrackedEvent',
      'name': name,
      'ts': ts.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      if (props != null) 'props': props?.toJson(),
      if (clientId != null) 'clientId': clientId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrackedEventImpl extends TrackedEvent {
  _TrackedEventImpl({
    required String name,
    required DateTime ts,
    String? sessionId,
    Map<String, String>? props,
    String? clientId,
  }) : super._(
         name: name,
         ts: ts,
         sessionId: sessionId,
         props: props,
         clientId: clientId,
       );

  /// Returns a shallow copy of this [TrackedEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TrackedEvent copyWith({
    String? name,
    DateTime? ts,
    Object? sessionId = _Undefined,
    Object? props = _Undefined,
    Object? clientId = _Undefined,
  }) {
    return TrackedEvent(
      name: name ?? this.name,
      ts: ts ?? this.ts,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      props: props is Map<String, String>?
          ? props
          : this.props?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      clientId: clientId is String? ? clientId : this.clientId,
    );
  }
}

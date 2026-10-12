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

/// Append-only event stream. SDK, link router and push delivery all write here.
abstract class Event
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Event._({
    this.id,
    required this.projectId,
    this.deviceId,
    required this.name,
    required this.ts,
    this.sessionId,
    this.props,
    this.appVersion,
  });

  factory Event({
    int? id,
    required int projectId,
    int? deviceId,
    required String name,
    required DateTime ts,
    String? sessionId,
    Map<String, String>? props,
    String? appVersion,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      deviceId: jsonSerialization['deviceId'] as int?,
      name: jsonSerialization['name'] as String,
      ts: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
      sessionId: jsonSerialization['sessionId'] as String?,
      props: jsonSerialization['props'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['props'],
            ),
      appVersion: jsonSerialization['appVersion'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  int? deviceId;

  String name;

  DateTime ts;

  String? sessionId;

  Map<String, String>? props;

  /// App version of the device when the server wrote the event, from
  /// device.appVersion, which the SDK reports on every start. Null for
  /// events without a device at hand (link_click, push_sent) and for events
  /// written before 25 September 2026. See the event explorer.
  String? appVersion;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Event copyWith({
    int? id,
    int? projectId,
    int? deviceId,
    String? name,
    DateTime? ts,
    String? sessionId,
    Map<String, String>? props,
    String? appVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (deviceId != null) 'deviceId': deviceId,
      'name': name,
      'ts': ts.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      if (props != null) 'props': props?.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (deviceId != null) 'deviceId': deviceId,
      'name': name,
      'ts': ts.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      if (props != null) 'props': props?.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EventImpl extends Event {
  _EventImpl({
    int? id,
    required int projectId,
    int? deviceId,
    required String name,
    required DateTime ts,
    String? sessionId,
    Map<String, String>? props,
    String? appVersion,
  }) : super._(
         id: id,
         projectId: projectId,
         deviceId: deviceId,
         name: name,
         ts: ts,
         sessionId: sessionId,
         props: props,
         appVersion: appVersion,
       );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    int? projectId,
    Object? deviceId = _Undefined,
    String? name,
    DateTime? ts,
    Object? sessionId = _Undefined,
    Object? props = _Undefined,
    Object? appVersion = _Undefined,
  }) {
    return Event(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
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
      appVersion: appVersion is String? ? appVersion : this.appVersion,
    );
  }
}

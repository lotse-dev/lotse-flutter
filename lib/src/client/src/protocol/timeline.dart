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
import 'app_user.dart' as _i2j2xfrn;
import 'device.dart' as _ilo09f9g;
import 'timeline_item.dart' as _ignyleo4;

/// Everything about one device, or about the devices the app identified as
/// one user, in the range [from, to), see AnalyticsEndpoint.deviceTimeline
/// and AnalyticsEndpoint.userTimeline. Newest first.
abstract class Timeline
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Timeline._({
    required this.from,
    required this.to,
    this.user,
    required this.devices,
    required this.items,
    required this.truncated,
  });

  factory Timeline({
    required DateTime from,
    required DateTime to,
    _i2j2xfrn.AppUser? user,
    required List<_ilo09f9g.Device> devices,
    required List<_ignyleo4.TimelineItem> items,
    required bool truncated,
  }) = _TimelineImpl;

  factory Timeline.fromJson(Map<String, dynamic> jsonSerialization) {
    return Timeline(
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      user: jsonSerialization['user'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_i2j2xfrn.AppUser>(
              jsonSerialization['user'],
            ),
      devices: _ist2d7e6.Protocol().deserialize<List<_ilo09f9g.Device>>(
        jsonSerialization['devices'],
      ),
      items: _ist2d7e6.Protocol().deserialize<List<_ignyleo4.TimelineItem>>(
        jsonSerialization['items'],
      ),
      truncated: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['truncated'],
      ),
    );
  }

  DateTime from;

  DateTime to;

  /// The user of a user timeline; for a device timeline the user the
  /// device was last identified as, null for an anonymous device.
  _i2j2xfrn.AppUser? user;

  /// The device of a device timeline, or every device whose device.userId
  /// is the user.
  List<_ilo09f9g.Device> devices;

  List<_ignyleo4.TimelineItem> items;

  /// True when a source had more than timelineSourceLimit entries in the
  /// range; the oldest of them are missing.
  bool truncated;

  /// Returns a shallow copy of this [Timeline]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Timeline copyWith({
    DateTime? from,
    DateTime? to,
    _i2j2xfrn.AppUser? user,
    List<_ilo09f9g.Device>? devices,
    List<_ignyleo4.TimelineItem>? items,
    bool? truncated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Timeline',
      'from': from.toJson(),
      'to': to.toJson(),
      if (user != null) 'user': user?.toJson(),
      'devices': devices.toJson(valueToJson: (v) => v.toJson()),
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'truncated': truncated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Timeline',
      'from': from.toJson(),
      'to': to.toJson(),
      if (user != null) 'user': user?.toJsonForProtocol(),
      'devices': devices.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'truncated': truncated,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimelineImpl extends Timeline {
  _TimelineImpl({
    required DateTime from,
    required DateTime to,
    _i2j2xfrn.AppUser? user,
    required List<_ilo09f9g.Device> devices,
    required List<_ignyleo4.TimelineItem> items,
    required bool truncated,
  }) : super._(
         from: from,
         to: to,
         user: user,
         devices: devices,
         items: items,
         truncated: truncated,
       );

  /// Returns a shallow copy of this [Timeline]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Timeline copyWith({
    DateTime? from,
    DateTime? to,
    Object? user = _Undefined,
    List<_ilo09f9g.Device>? devices,
    List<_ignyleo4.TimelineItem>? items,
    bool? truncated,
  }) {
    return Timeline(
      from: from ?? this.from,
      to: to ?? this.to,
      user: user is _i2j2xfrn.AppUser? ? user : this.user?.copyWith(),
      devices: devices ?? this.devices.map((e0) => e0.copyWith()).toList(),
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      truncated: truncated ?? this.truncated,
    );
  }
}

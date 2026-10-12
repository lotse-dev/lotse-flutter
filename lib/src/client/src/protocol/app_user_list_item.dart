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

/// A user in the console's list, see AnalyticsEndpoint.listUsers.
abstract class AppUserListItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppUserListItem._({
    required this.user,
    required this.devices,
  });

  factory AppUserListItem({
    required _i2j2xfrn.AppUser user,
    required int devices,
  }) = _AppUserListItemImpl;

  factory AppUserListItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserListItem(
      user: _ist2d7e6.Protocol().deserialize<_i2j2xfrn.AppUser>(
        jsonSerialization['user'],
      ),
      devices: jsonSerialization['devices'] as int,
    );
  }

  _i2j2xfrn.AppUser user;

  /// Devices whose device.userId is the user.
  int devices;

  /// Returns a shallow copy of this [AppUserListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUserListItem copyWith({
    _i2j2xfrn.AppUser? user,
    int? devices,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserListItem',
      'user': user.toJson(),
      'devices': devices,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUserListItem',
      'user': user.toJsonForProtocol(),
      'devices': devices,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AppUserListItemImpl extends AppUserListItem {
  _AppUserListItemImpl({
    required _i2j2xfrn.AppUser user,
    required int devices,
  }) : super._(
         user: user,
         devices: devices,
       );

  /// Returns a shallow copy of this [AppUserListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppUserListItem copyWith({
    _i2j2xfrn.AppUser? user,
    int? devices,
  }) {
    return AppUserListItem(
      user: user ?? this.user.copyWith(),
      devices: devices ?? this.devices,
    );
  }
}

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
import 'setup_check_status.dart' as _i10jnq79;

/// One check of the setup diagnosis, see ProjectEndpoint.diagnoseSetup.
abstract class SetupCheck
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SetupCheck._({
    required this.key,
    required this.title,
    required this.status,
    required this.detail,
    this.fix,
    this.appId,
  });

  factory SetupCheck({
    required String key,
    required String title,
    required _i10jnq79.SetupCheckStatus status,
    required String detail,
    String? fix,
    int? appId,
  }) = _SetupCheckImpl;

  factory SetupCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupCheck(
      key: jsonSerialization['key'] as String,
      title: jsonSerialization['title'] as String,
      status: _i10jnq79.SetupCheckStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      detail: jsonSerialization['detail'] as String,
      fix: jsonSerialization['fix'] as String?,
      appId: jsonSerialization['appId'] as int?,
    );
  }

  /// Stable key, e.g. `android.fingerprints`.
  String key;

  String title;

  _i10jnq79.SetupCheckStatus status;

  /// What was found.
  String detail;

  /// What to do about it, null when nothing.
  String? fix;

  /// The app the check is about, null for checks of the project.
  int? appId;

  /// Returns a shallow copy of this [SetupCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SetupCheck copyWith({
    String? key,
    String? title,
    _i10jnq79.SetupCheckStatus? status,
    String? detail,
    String? fix,
    int? appId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupCheck',
      'key': key,
      'title': title,
      'status': status.toJson(),
      'detail': detail,
      if (fix != null) 'fix': fix,
      if (appId != null) 'appId': appId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupCheck',
      'key': key,
      'title': title,
      'status': status.toJson(),
      'detail': detail,
      if (fix != null) 'fix': fix,
      if (appId != null) 'appId': appId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SetupCheckImpl extends SetupCheck {
  _SetupCheckImpl({
    required String key,
    required String title,
    required _i10jnq79.SetupCheckStatus status,
    required String detail,
    String? fix,
    int? appId,
  }) : super._(
         key: key,
         title: title,
         status: status,
         detail: detail,
         fix: fix,
         appId: appId,
       );

  /// Returns a shallow copy of this [SetupCheck]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SetupCheck copyWith({
    String? key,
    String? title,
    _i10jnq79.SetupCheckStatus? status,
    String? detail,
    Object? fix = _Undefined,
    Object? appId = _Undefined,
  }) {
    return SetupCheck(
      key: key ?? this.key,
      title: title ?? this.title,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      fix: fix is String? ? fix : this.fix,
      appId: appId is int? ? appId : this.appId,
    );
  }
}

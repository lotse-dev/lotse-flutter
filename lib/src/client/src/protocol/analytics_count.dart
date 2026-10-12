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

/// One row of a ranking in AnalyticsOverview: an event name, a screen or an
/// app version with how often it occurred.
abstract class AnalyticsCount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AnalyticsCount._({
    this.name,
    required this.count,
  });

  factory AnalyticsCount({
    String? name,
    required int count,
  }) = _AnalyticsCountImpl;

  factory AnalyticsCount.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnalyticsCount(
      name: jsonSerialization['name'] as String?,
      count: jsonSerialization['count'] as int,
    );
  }

  /// Null only in AnalyticsOverview.appVersions, for devices that reported
  /// no version.
  String? name;

  int count;

  /// Returns a shallow copy of this [AnalyticsCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AnalyticsCount copyWith({
    String? name,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnalyticsCount',
      if (name != null) 'name': name,
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AnalyticsCount',
      if (name != null) 'name': name,
      'count': count,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnalyticsCountImpl extends AnalyticsCount {
  _AnalyticsCountImpl({
    String? name,
    required int count,
  }) : super._(
         name: name,
         count: count,
       );

  /// Returns a shallow copy of this [AnalyticsCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AnalyticsCount copyWith({
    Object? name = _Undefined,
    int? count,
  }) {
    return AnalyticsCount(
      name: name is String? ? name : this.name,
      count: count ?? this.count,
    );
  }
}

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
import 'setup_check.dart' as _ie45uxmr;
import 'setup_traffic.dart' as _i3mfntce;

/// Why a link of the project opens in the browser instead of the app, see
/// ProjectEndpoint.diagnoseSetup.
abstract class SetupDiagnosis
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SetupDiagnosis._({
    required this.linkHost,
    this.slug,
    required this.checkedAt,
    required this.summary,
    required this.checks,
    required this.traffic,
    required this.intentFilter,
  });

  factory SetupDiagnosis({
    required String linkHost,
    String? slug,
    required DateTime checkedAt,
    required String summary,
    required List<_ie45uxmr.SetupCheck> checks,
    required _i3mfntce.SetupTraffic traffic,
    required String intentFilter,
  }) = _SetupDiagnosisImpl;

  factory SetupDiagnosis.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupDiagnosis(
      linkHost: jsonSerialization['linkHost'] as String,
      slug: jsonSerialization['slug'] as String?,
      checkedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['checkedAt'],
      ),
      summary: jsonSerialization['summary'] as String,
      checks: _ist2d7e6.Protocol().deserialize<List<_ie45uxmr.SetupCheck>>(
        jsonSerialization['checks'],
      ),
      traffic: _ist2d7e6.Protocol().deserialize<_i3mfntce.SetupTraffic>(
        jsonSerialization['traffic'],
      ),
      intentFilter: jsonSerialization['intentFilter'] as String,
    );
  }

  /// The link domain, `<handle>.lotse.dev`.
  String linkHost;

  /// The link the diagnosis is narrowed to, null for the whole project.
  String? slug;

  DateTime checkedAt;

  /// The most likely reason in one or two sentences, or that the setup
  /// looks right and what else sends a link to the browser.
  String summary;

  List<_ie45uxmr.SetupCheck> checks;

  _i3mfntce.SetupTraffic traffic;

  /// The intent filter the Android app needs, to copy into its manifest.
  String intentFilter;

  /// Returns a shallow copy of this [SetupDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SetupDiagnosis copyWith({
    String? linkHost,
    String? slug,
    DateTime? checkedAt,
    String? summary,
    List<_ie45uxmr.SetupCheck>? checks,
    _i3mfntce.SetupTraffic? traffic,
    String? intentFilter,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupDiagnosis',
      'linkHost': linkHost,
      if (slug != null) 'slug': slug,
      'checkedAt': checkedAt.toJson(),
      'summary': summary,
      'checks': checks.toJson(valueToJson: (v) => v.toJson()),
      'traffic': traffic.toJson(),
      'intentFilter': intentFilter,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupDiagnosis',
      'linkHost': linkHost,
      if (slug != null) 'slug': slug,
      'checkedAt': checkedAt.toJson(),
      'summary': summary,
      'checks': checks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'traffic': traffic.toJsonForProtocol(),
      'intentFilter': intentFilter,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SetupDiagnosisImpl extends SetupDiagnosis {
  _SetupDiagnosisImpl({
    required String linkHost,
    String? slug,
    required DateTime checkedAt,
    required String summary,
    required List<_ie45uxmr.SetupCheck> checks,
    required _i3mfntce.SetupTraffic traffic,
    required String intentFilter,
  }) : super._(
         linkHost: linkHost,
         slug: slug,
         checkedAt: checkedAt,
         summary: summary,
         checks: checks,
         traffic: traffic,
         intentFilter: intentFilter,
       );

  /// Returns a shallow copy of this [SetupDiagnosis]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SetupDiagnosis copyWith({
    String? linkHost,
    Object? slug = _Undefined,
    DateTime? checkedAt,
    String? summary,
    List<_ie45uxmr.SetupCheck>? checks,
    _i3mfntce.SetupTraffic? traffic,
    String? intentFilter,
  }) {
    return SetupDiagnosis(
      linkHost: linkHost ?? this.linkHost,
      slug: slug is String? ? slug : this.slug,
      checkedAt: checkedAt ?? this.checkedAt,
      summary: summary ?? this.summary,
      checks: checks ?? this.checks.map((e0) => e0.copyWith()).toList(),
      traffic: traffic ?? this.traffic.copyWith(),
      intentFilter: intentFilter ?? this.intentFilter,
    );
  }
}

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
import 'retention_row.dart' as _iva6i66v;

/// The installs of one week, see RetentionReport.
abstract class RetentionCohort
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RetentionCohort._({
    required this.weekStart,
    required this.total,
    required this.parts,
  });

  factory RetentionCohort({
    required DateTime weekStart,
    required _iva6i66v.RetentionRow total,
    required List<_iva6i66v.RetentionRow> parts,
  }) = _RetentionCohortImpl;

  factory RetentionCohort.fromJson(Map<String, dynamic> jsonSerialization) {
    return RetentionCohort(
      weekStart: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['weekStart'],
      ),
      total: _ist2d7e6.Protocol().deserialize<_iva6i66v.RetentionRow>(
        jsonSerialization['total'],
      ),
      parts: _ist2d7e6.Protocol().deserialize<List<_iva6i66v.RetentionRow>>(
        jsonSerialization['parts'],
      ),
    );
  }

  /// Start of the week: RetentionReport.from plus a multiple of 7 days. The
  /// week ends 7 days later or at RetentionReport.to.
  DateTime weekStart;

  /// All installs of the week.
  _iva6i66v.RetentionRow total;

  /// The installs of the week split by RetentionReport.split, most installs
  /// first, organic last. Empty when the report is not split.
  List<_iva6i66v.RetentionRow> parts;

  /// Returns a shallow copy of this [RetentionCohort]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RetentionCohort copyWith({
    DateTime? weekStart,
    _iva6i66v.RetentionRow? total,
    List<_iva6i66v.RetentionRow>? parts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RetentionCohort',
      'weekStart': weekStart.toJson(),
      'total': total.toJson(),
      'parts': parts.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RetentionCohort',
      'weekStart': weekStart.toJson(),
      'total': total.toJsonForProtocol(),
      'parts': parts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RetentionCohortImpl extends RetentionCohort {
  _RetentionCohortImpl({
    required DateTime weekStart,
    required _iva6i66v.RetentionRow total,
    required List<_iva6i66v.RetentionRow> parts,
  }) : super._(weekStart: weekStart, total: total, parts: parts);

  /// Returns a shallow copy of this [RetentionCohort]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RetentionCohort copyWith({
    DateTime? weekStart,
    _iva6i66v.RetentionRow? total,
    List<_iva6i66v.RetentionRow>? parts,
  }) {
    return RetentionCohort(
      weekStart: weekStart ?? this.weekStart,
      total: total ?? this.total.copyWith(),
      parts: parts ?? this.parts.map((e0) => e0.copyWith()).toList(),
    );
  }
}

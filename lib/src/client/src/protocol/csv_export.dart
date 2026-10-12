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

/// A CSV file made by AnalyticsEndpoint.exportCsv: RFC 4180 with CRLF,
/// UTF-8 with a byte order mark, times in ISO 8601 UTC.
abstract class CsvExport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CsvExport._({
    required this.fileName,
    required this.content,
    required this.rows,
    required this.truncated,
  });

  factory CsvExport({
    required String fileName,
    required String content,
    required int rows,
    required bool truncated,
  }) = _CsvExportImpl;

  factory CsvExport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CsvExport(
      fileName: jsonSerialization['fileName'] as String,
      content: jsonSerialization['content'] as String,
      rows: jsonSerialization['rows'] as int,
      truncated: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['truncated'],
      ),
    );
  }

  /// `<handle>-<kind>-<date>.csv`; never holds data of app users.
  String fileName;

  String content;

  /// Data rows, not counting the header.
  int rows;

  /// True when the table had more than csvExportMaxRows rows or
  /// csvExportMaxBytes bytes, or a source of a timeline was cut; the file
  /// holds the first rows.
  bool truncated;

  /// Returns a shallow copy of this [CsvExport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CsvExport copyWith({
    String? fileName,
    String? content,
    int? rows,
    bool? truncated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CsvExport',
      'fileName': fileName,
      'content': content,
      'rows': rows,
      'truncated': truncated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CsvExport',
      'fileName': fileName,
      'content': content,
      'rows': rows,
      'truncated': truncated,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CsvExportImpl extends CsvExport {
  _CsvExportImpl({
    required String fileName,
    required String content,
    required int rows,
    required bool truncated,
  }) : super._(
         fileName: fileName,
         content: content,
         rows: rows,
         truncated: truncated,
       );

  /// Returns a shallow copy of this [CsvExport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CsvExport copyWith({
    String? fileName,
    String? content,
    int? rows,
    bool? truncated,
  }) {
    return CsvExport(
      fileName: fileName ?? this.fileName,
      content: content ?? this.content,
      rows: rows ?? this.rows,
      truncated: truncated ?? this.truncated,
    );
  }
}

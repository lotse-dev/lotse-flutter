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
import 'survey_response_item.dart' as _ibd3jznw;

/// One page of the answers of a survey, newest first. The next page starts
/// below nextBeforeId; null on the last page.
abstract class SurveyResponsePage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SurveyResponsePage._({
    required this.items,
    required this.total,
    this.nextBeforeId,
  });

  factory SurveyResponsePage({
    required List<_ibd3jznw.SurveyResponseItem> items,
    required int total,
    int? nextBeforeId,
  }) = _SurveyResponsePageImpl;

  factory SurveyResponsePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SurveyResponsePage(
      items: _ist2d7e6.Protocol()
          .deserialize<List<_ibd3jznw.SurveyResponseItem>>(
            jsonSerialization['items'],
          ),
      total: jsonSerialization['total'] as int,
      nextBeforeId: jsonSerialization['nextBeforeId'] as int?,
    );
  }

  List<_ibd3jznw.SurveyResponseItem> items;

  /// Answers that match the filters across all pages.
  int total;

  int? nextBeforeId;

  /// Returns a shallow copy of this [SurveyResponsePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SurveyResponsePage copyWith({
    List<_ibd3jznw.SurveyResponseItem>? items,
    int? total,
    int? nextBeforeId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SurveyResponsePage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      if (nextBeforeId != null) 'nextBeforeId': nextBeforeId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SurveyResponsePage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      if (nextBeforeId != null) 'nextBeforeId': nextBeforeId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SurveyResponsePageImpl extends SurveyResponsePage {
  _SurveyResponsePageImpl({
    required List<_ibd3jznw.SurveyResponseItem> items,
    required int total,
    int? nextBeforeId,
  }) : super._(items: items, total: total, nextBeforeId: nextBeforeId);

  /// Returns a shallow copy of this [SurveyResponsePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SurveyResponsePage copyWith({
    List<_ibd3jznw.SurveyResponseItem>? items,
    int? total,
    Object? nextBeforeId = _Undefined,
  }) {
    return SurveyResponsePage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      nextBeforeId: nextBeforeId is int? ? nextBeforeId : this.nextBeforeId,
    );
  }
}

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
import 'feedback_list_item.dart' as _i7gab86f;

/// One page of the feedback inbox, newest first.
abstract class FeedbackPage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackPage._({
    required this.items,
    required this.total,
    required this.pageSize,
  });

  factory FeedbackPage({
    required List<_i7gab86f.FeedbackListItem> items,
    required int total,
    required int pageSize,
  }) = _FeedbackPageImpl;

  factory FeedbackPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackPage(
      items: _ist2d7e6.Protocol().deserialize<List<_i7gab86f.FeedbackListItem>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
    );
  }

  List<_i7gab86f.FeedbackListItem> items;

  /// Messages that match the filters across all pages.
  int total;

  int pageSize;

  /// Returns a shallow copy of this [FeedbackPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackPage copyWith({
    List<_i7gab86f.FeedbackListItem>? items,
    int? total,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'pageSize': pageSize,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FeedbackPageImpl extends FeedbackPage {
  _FeedbackPageImpl({
    required List<_i7gab86f.FeedbackListItem> items,
    required int total,
    required int pageSize,
  }) : super._(items: items, total: total, pageSize: pageSize);

  /// Returns a shallow copy of this [FeedbackPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackPage copyWith({
    List<_i7gab86f.FeedbackListItem>? items,
    int? total,
    int? pageSize,
  }) {
    return FeedbackPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

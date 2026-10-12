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
import 'feature_request_status.dart' as _ios6zwvp;

/// An idea as a device sees it on the feature board. Carries nothing the
/// console keeps around it.
abstract class FeatureBoardItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeatureBoardItem._({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.voteCount,
    required this.hasVoted,
    required this.createdAt,
  });

  factory FeatureBoardItem({
    required int id,
    required String title,
    required String description,
    required _ios6zwvp.FeatureRequestStatus status,
    required int voteCount,
    required bool hasVoted,
    required DateTime createdAt,
  }) = _FeatureBoardItemImpl;

  factory FeatureBoardItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeatureBoardItem(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      status: _ios6zwvp.FeatureRequestStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      voteCount: jsonSerialization['voteCount'] as int,
      hasVoted: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasVoted']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String title;

  String description;

  _ios6zwvp.FeatureRequestStatus status;

  int voteCount;

  /// Whether the asking device voted for it.
  bool hasVoted;

  DateTime createdAt;

  /// Returns a shallow copy of this [FeatureBoardItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeatureBoardItem copyWith({
    int? id,
    String? title,
    String? description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    bool? hasVoted,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeatureBoardItem',
      'id': id,
      'title': title,
      'description': description,
      'status': status.toJson(),
      'voteCount': voteCount,
      'hasVoted': hasVoted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeatureBoardItem',
      'id': id,
      'title': title,
      'description': description,
      'status': status.toJson(),
      'voteCount': voteCount,
      'hasVoted': hasVoted,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FeatureBoardItemImpl extends FeatureBoardItem {
  _FeatureBoardItemImpl({
    required int id,
    required String title,
    required String description,
    required _ios6zwvp.FeatureRequestStatus status,
    required int voteCount,
    required bool hasVoted,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         description: description,
         status: status,
         voteCount: voteCount,
         hasVoted: hasVoted,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FeatureBoardItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeatureBoardItem copyWith({
    int? id,
    String? title,
    String? description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    bool? hasVoted,
    DateTime? createdAt,
  }) {
    return FeatureBoardItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      voteCount: voteCount ?? this.voteCount,
      hasVoted: hasVoted ?? this.hasVoted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

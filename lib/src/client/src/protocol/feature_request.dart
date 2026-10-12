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

/// An idea on the feature board of a project. The team creates it in the
/// console, devices vote on it.
abstract class FeatureRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeatureRequest._({
    this.id,
    required this.projectId,
    required this.title,
    required this.description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    this.createdByDeviceId,
    this.sourceFeedbackId,
    this.mergedIntoId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _ios6zwvp.FeatureRequestStatus.open,
       voteCount = voteCount ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory FeatureRequest({
    int? id,
    required int projectId,
    required String title,
    required String description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    int? createdByDeviceId,
    int? sourceFeedbackId,
    int? mergedIntoId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FeatureRequestImpl;

  factory FeatureRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeatureRequest(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _ios6zwvp.FeatureRequestStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      voteCount: jsonSerialization['voteCount'] as int?,
      createdByDeviceId: jsonSerialization['createdByDeviceId'] as int?,
      sourceFeedbackId: jsonSerialization['sourceFeedbackId'] as int?,
      mergedIntoId: jsonSerialization['mergedIntoId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  String title;

  String description;

  _ios6zwvp.FeatureRequestStatus status;

  /// Rows in feature_vote for this idea. Denormalised so the board sorts
  /// without counting; kept in the transaction that writes the vote.
  int voteCount;

  /// Always null today: only the team creates ideas. The column exists so
  /// that submitting from the SDK can be added without a migration.
  int? createdByDeviceId;

  /// The feedback message the idea was created from.
  int? sourceFeedbackId;

  /// Set on a duplicate: its votes moved to this idea of the same project and
  /// it is archived for good.
  int? mergedIntoId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [FeatureRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeatureRequest copyWith({
    int? id,
    int? projectId,
    String? title,
    String? description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    int? createdByDeviceId,
    int? sourceFeedbackId,
    int? mergedIntoId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeatureRequest',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.toJson(),
      'voteCount': voteCount,
      if (createdByDeviceId != null) 'createdByDeviceId': createdByDeviceId,
      if (sourceFeedbackId != null) 'sourceFeedbackId': sourceFeedbackId,
      if (mergedIntoId != null) 'mergedIntoId': mergedIntoId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeatureRequest',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.toJson(),
      'voteCount': voteCount,
      if (createdByDeviceId != null) 'createdByDeviceId': createdByDeviceId,
      if (sourceFeedbackId != null) 'sourceFeedbackId': sourceFeedbackId,
      if (mergedIntoId != null) 'mergedIntoId': mergedIntoId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeatureRequestImpl extends FeatureRequest {
  _FeatureRequestImpl({
    int? id,
    required int projectId,
    required String title,
    required String description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    int? createdByDeviceId,
    int? sourceFeedbackId,
    int? mergedIntoId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         title: title,
         description: description,
         status: status,
         voteCount: voteCount,
         createdByDeviceId: createdByDeviceId,
         sourceFeedbackId: sourceFeedbackId,
         mergedIntoId: mergedIntoId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FeatureRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeatureRequest copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? title,
    String? description,
    _ios6zwvp.FeatureRequestStatus? status,
    int? voteCount,
    Object? createdByDeviceId = _Undefined,
    Object? sourceFeedbackId = _Undefined,
    Object? mergedIntoId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeatureRequest(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      voteCount: voteCount ?? this.voteCount,
      createdByDeviceId: createdByDeviceId is int?
          ? createdByDeviceId
          : this.createdByDeviceId,
      sourceFeedbackId: sourceFeedbackId is int?
          ? sourceFeedbackId
          : this.sourceFeedbackId,
      mergedIntoId: mergedIntoId is int? ? mergedIntoId : this.mergedIntoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

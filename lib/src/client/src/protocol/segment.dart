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

/// A named audience of a project, saved in the console to pick when
/// creating a campaign. The campaign copies the predicate, so changing or
/// deleting the segment never changes who a campaign went to.
abstract class Segment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Segment._({
    this.id,
    required this.projectId,
    required this.name,
    required this.predicate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Segment({
    int? id,
    required int projectId,
    required String name,
    required Map<String, dynamic> predicate,
    DateTime? createdAt,
  }) = _SegmentImpl;

  factory Segment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Segment(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      name: jsonSerialization['name'] as String,
      predicate: _ist2d7e6.Protocol().deserialize<Map<String, dynamic>>(
        jsonSerialization['predicate'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// Trimmed, 1 to 64 characters, unique per project.
  String name;

  /// Audience predicate, see ARCHITECTURE.md, section "Segmente". Stored
  /// validated and never null: a segment without conditions is not saved.
  Map<String, dynamic> predicate;

  DateTime createdAt;

  /// Returns a shallow copy of this [Segment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Segment copyWith({
    int? id,
    int? projectId,
    String? name,
    Map<String, dynamic>? predicate,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Segment',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'predicate': predicate.toJson(
        valueToJson: (v) => _ist2d7e6.Protocol().dynamicFieldToJson(v),
      ),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Segment',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'predicate': predicate.toJson(
        valueToJson: (v) =>
            _ist2d7e6.Protocol().dynamicFieldToJson(v, forProtocol: true),
      ),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SegmentImpl extends Segment {
  _SegmentImpl({
    int? id,
    required int projectId,
    required String name,
    required Map<String, dynamic> predicate,
    DateTime? createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         predicate: predicate,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Segment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Segment copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? name,
    Map<String, dynamic>? predicate,
    DateTime? createdAt,
  }) {
    return Segment(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      predicate:
          predicate ??
          this.predicate.map((key0, value0) => MapEntry(key0, value0)),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

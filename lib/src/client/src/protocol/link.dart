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

/// A short link under <project handle>.lotse.dev/l/<slug>. Every project has
/// its own link domain, so the slug is unique per project only.
abstract class Link
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Link._({
    this.id,
    required this.projectId,
    required this.slug,
    required this.targetPath,
    this.campaign,
    this.source,
    this.medium,
    this.fallbackIos,
    this.fallbackAndroid,
    this.fallbackWeb,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Link({
    int? id,
    required int projectId,
    required String slug,
    required String targetPath,
    String? campaign,
    String? source,
    String? medium,
    String? fallbackIos,
    String? fallbackAndroid,
    String? fallbackWeb,
    DateTime? createdAt,
  }) = _LinkImpl;

  factory Link.fromJson(Map<String, dynamic> jsonSerialization) {
    return Link(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      slug: jsonSerialization['slug'] as String,
      targetPath: jsonSerialization['targetPath'] as String,
      campaign: jsonSerialization['campaign'] as String?,
      source: jsonSerialization['source'] as String?,
      medium: jsonSerialization['medium'] as String?,
      fallbackIos: jsonSerialization['fallbackIos'] as String?,
      fallbackAndroid: jsonSerialization['fallbackAndroid'] as String?,
      fallbackWeb: jsonSerialization['fallbackWeb'] as String?,
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

  String slug;

  /// App route the SDK hands to the app, e.g. /offer/42.
  String targetPath;

  String? campaign;

  String? source;

  String? medium;

  /// Used on iOS when the project has no iOS app with an App Store ID.
  String? fallbackIos;

  /// Used on Android when the project has no Android app.
  String? fallbackAndroid;

  /// Used on desktop, for bots and when no platform destination exists.
  String? fallbackWeb;

  DateTime createdAt;

  /// Returns a shallow copy of this [Link]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Link copyWith({
    int? id,
    int? projectId,
    String? slug,
    String? targetPath,
    String? campaign,
    String? source,
    String? medium,
    String? fallbackIos,
    String? fallbackAndroid,
    String? fallbackWeb,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Link',
      if (id != null) 'id': id,
      'projectId': projectId,
      'slug': slug,
      'targetPath': targetPath,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
      if (fallbackIos != null) 'fallbackIos': fallbackIos,
      if (fallbackAndroid != null) 'fallbackAndroid': fallbackAndroid,
      if (fallbackWeb != null) 'fallbackWeb': fallbackWeb,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Link',
      if (id != null) 'id': id,
      'projectId': projectId,
      'slug': slug,
      'targetPath': targetPath,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
      if (fallbackIos != null) 'fallbackIos': fallbackIos,
      if (fallbackAndroid != null) 'fallbackAndroid': fallbackAndroid,
      if (fallbackWeb != null) 'fallbackWeb': fallbackWeb,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LinkImpl extends Link {
  _LinkImpl({
    int? id,
    required int projectId,
    required String slug,
    required String targetPath,
    String? campaign,
    String? source,
    String? medium,
    String? fallbackIos,
    String? fallbackAndroid,
    String? fallbackWeb,
    DateTime? createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         slug: slug,
         targetPath: targetPath,
         campaign: campaign,
         source: source,
         medium: medium,
         fallbackIos: fallbackIos,
         fallbackAndroid: fallbackAndroid,
         fallbackWeb: fallbackWeb,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Link]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Link copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? slug,
    String? targetPath,
    Object? campaign = _Undefined,
    Object? source = _Undefined,
    Object? medium = _Undefined,
    Object? fallbackIos = _Undefined,
    Object? fallbackAndroid = _Undefined,
    Object? fallbackWeb = _Undefined,
    DateTime? createdAt,
  }) {
    return Link(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      slug: slug ?? this.slug,
      targetPath: targetPath ?? this.targetPath,
      campaign: campaign is String? ? campaign : this.campaign,
      source: source is String? ? source : this.source,
      medium: medium is String? ? medium : this.medium,
      fallbackIos: fallbackIos is String? ? fallbackIos : this.fallbackIos,
      fallbackAndroid: fallbackAndroid is String?
          ? fallbackAndroid
          : this.fallbackAndroid,
      fallbackWeb: fallbackWeb is String? ? fallbackWeb : this.fallbackWeb,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

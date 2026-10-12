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

/// What the SDK learns about a tapped link: the app route and the campaign.
abstract class ResolvedLink
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResolvedLink._({
    required this.slug,
    required this.targetPath,
    this.campaign,
    this.source,
    this.medium,
  });

  factory ResolvedLink({
    required String slug,
    required String targetPath,
    String? campaign,
    String? source,
    String? medium,
  }) = _ResolvedLinkImpl;

  factory ResolvedLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResolvedLink(
      slug: jsonSerialization['slug'] as String,
      targetPath: jsonSerialization['targetPath'] as String,
      campaign: jsonSerialization['campaign'] as String?,
      source: jsonSerialization['source'] as String?,
      medium: jsonSerialization['medium'] as String?,
    );
  }

  String slug;

  String targetPath;

  String? campaign;

  String? source;

  String? medium;

  /// Returns a shallow copy of this [ResolvedLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResolvedLink copyWith({
    String? slug,
    String? targetPath,
    String? campaign,
    String? source,
    String? medium,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResolvedLink',
      'slug': slug,
      'targetPath': targetPath,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResolvedLink',
      'slug': slug,
      'targetPath': targetPath,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResolvedLinkImpl extends ResolvedLink {
  _ResolvedLinkImpl({
    required String slug,
    required String targetPath,
    String? campaign,
    String? source,
    String? medium,
  }) : super._(
         slug: slug,
         targetPath: targetPath,
         campaign: campaign,
         source: source,
         medium: medium,
       );

  /// Returns a shallow copy of this [ResolvedLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResolvedLink copyWith({
    String? slug,
    String? targetPath,
    Object? campaign = _Undefined,
    Object? source = _Undefined,
    Object? medium = _Undefined,
  }) {
    return ResolvedLink(
      slug: slug ?? this.slug,
      targetPath: targetPath ?? this.targetPath,
      campaign: campaign is String? ? campaign : this.campaign,
      source: source is String? ? source : this.source,
      medium: medium is String? ? medium : this.medium,
    );
  }
}

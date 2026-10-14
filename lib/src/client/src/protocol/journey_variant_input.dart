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

/// The push of one variant of a journey, as the console sends it. Checked
/// like a campaign by checkCampaignInput.
abstract class JourneyVariantInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyVariantInput._({required this.title, required this.body, this.linkId});

  factory JourneyVariantInput({
    required String title,
    required String body,
    int? linkId,
  }) = _JourneyVariantInputImpl;

  factory JourneyVariantInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyVariantInput(
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      linkId: jsonSerialization['linkId'] as int?,
    );
  }

  String title;

  String body;

  /// Link whose target path the push opens; a link of the project.
  int? linkId;

  /// Returns a shallow copy of this [JourneyVariantInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyVariantInput copyWith({String? title, String? body, int? linkId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyVariantInput',
      'title': title,
      'body': body,
      if (linkId != null) 'linkId': linkId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyVariantInput',
      'title': title,
      'body': body,
      if (linkId != null) 'linkId': linkId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyVariantInputImpl extends JourneyVariantInput {
  _JourneyVariantInputImpl({
    required String title,
    required String body,
    int? linkId,
  }) : super._(title: title, body: body, linkId: linkId);

  /// Returns a shallow copy of this [JourneyVariantInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyVariantInput copyWith({
    String? title,
    String? body,
    Object? linkId = _Undefined,
  }) {
    return JourneyVariantInput(
      title: title ?? this.title,
      body: body ?? this.body,
      linkId: linkId is int? ? linkId : this.linkId,
    );
  }
}

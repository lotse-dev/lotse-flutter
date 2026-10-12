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
import 'in_app_message_style.dart' as _iv76hups;

/// An in-app message as `SdkEndpoint.inAppMessages` hands it to a device.
/// The SDK turns it into its own `LotseInAppMessage`.
abstract class SdkInAppMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SdkInAppMessage._({
    required this.id,
    required this.title,
    required this.body,
    required this.style,
    this.buttonLabel,
    this.targetPath,
    this.slug,
  });

  factory SdkInAppMessage({
    required int id,
    required String title,
    required String body,
    required _iv76hups.InAppMessageStyle style,
    String? buttonLabel,
    String? targetPath,
    String? slug,
  }) = _SdkInAppMessageImpl;

  factory SdkInAppMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SdkInAppMessage(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      style: _iv76hups.InAppMessageStyle.fromJson(
        (jsonSerialization['style'] as String),
      ),
      buttonLabel: jsonSerialization['buttonLabel'] as String?,
      targetPath: jsonSerialization['targetPath'] as String?,
      slug: jsonSerialization['slug'] as String?,
    );
  }

  int id;

  String title;

  String body;

  _iv76hups.InAppMessageStyle style;

  String? buttonLabel;

  /// App route of the link, null without one.
  String? targetPath;

  String? slug;

  /// Returns a shallow copy of this [SdkInAppMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SdkInAppMessage copyWith({
    int? id,
    String? title,
    String? body,
    _iv76hups.InAppMessageStyle? style,
    String? buttonLabel,
    String? targetPath,
    String? slug,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SdkInAppMessage',
      'id': id,
      'title': title,
      'body': body,
      'style': style.toJson(),
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
      if (targetPath != null) 'targetPath': targetPath,
      if (slug != null) 'slug': slug,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SdkInAppMessage',
      'id': id,
      'title': title,
      'body': body,
      'style': style.toJson(),
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
      if (targetPath != null) 'targetPath': targetPath,
      if (slug != null) 'slug': slug,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SdkInAppMessageImpl extends SdkInAppMessage {
  _SdkInAppMessageImpl({
    required int id,
    required String title,
    required String body,
    required _iv76hups.InAppMessageStyle style,
    String? buttonLabel,
    String? targetPath,
    String? slug,
  }) : super._(
         id: id,
         title: title,
         body: body,
         style: style,
         buttonLabel: buttonLabel,
         targetPath: targetPath,
         slug: slug,
       );

  /// Returns a shallow copy of this [SdkInAppMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SdkInAppMessage copyWith({
    int? id,
    String? title,
    String? body,
    _iv76hups.InAppMessageStyle? style,
    Object? buttonLabel = _Undefined,
    Object? targetPath = _Undefined,
    Object? slug = _Undefined,
  }) {
    return SdkInAppMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      style: style ?? this.style,
      buttonLabel: buttonLabel is String? ? buttonLabel : this.buttonLabel,
      targetPath: targetPath is String? ? targetPath : this.targetPath,
      slug: slug is String? ? slug : this.slug,
    );
  }
}

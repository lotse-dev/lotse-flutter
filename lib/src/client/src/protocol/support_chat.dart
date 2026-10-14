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

/// What the SDK needs to open the support chat of one device.
abstract class SupportChat
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SupportChat._({required this.enabled, this.feedbackId});

  factory SupportChat({required bool enabled, int? feedbackId}) =
      _SupportChatImpl;

  factory SupportChat.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportChat(
      enabled: _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      feedbackId: jsonSerialization['feedbackId'] as int?,
    );
  }

  /// Whether the project accepts new conversations of the category question.
  bool enabled;

  /// The running conversation of the device: its newest question that is
  /// neither done nor dismissed. Set while the chat is off too, because an
  /// existing conversation stays readable and answerable.
  int? feedbackId;

  /// Returns a shallow copy of this [SupportChat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SupportChat copyWith({bool? enabled, int? feedbackId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportChat',
      'enabled': enabled,
      if (feedbackId != null) 'feedbackId': feedbackId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportChat',
      'enabled': enabled,
      if (feedbackId != null) 'feedbackId': feedbackId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportChatImpl extends SupportChat {
  _SupportChatImpl({required bool enabled, int? feedbackId})
    : super._(enabled: enabled, feedbackId: feedbackId);

  /// Returns a shallow copy of this [SupportChat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SupportChat copyWith({bool? enabled, Object? feedbackId = _Undefined}) {
    return SupportChat(
      enabled: enabled ?? this.enabled,
      feedbackId: feedbackId is int? ? feedbackId : this.feedbackId,
    );
  }
}

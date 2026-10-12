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
import 'in_app_message.dart' as _icz8bdg4;

/// One row of the in-app messages in the console, with the distinct devices
/// that saw and tapped the message since it became active.
abstract class InAppMessageListItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InAppMessageListItem._({
    required this.message,
    required this.viewed,
    required this.tapped,
  });

  factory InAppMessageListItem({
    required _icz8bdg4.InAppMessage message,
    required int viewed,
    required int tapped,
  }) = _InAppMessageListItemImpl;

  factory InAppMessageListItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InAppMessageListItem(
      message: _ist2d7e6.Protocol().deserialize<_icz8bdg4.InAppMessage>(
        jsonSerialization['message'],
      ),
      viewed: jsonSerialization['viewed'] as int,
      tapped: jsonSerialization['tapped'] as int,
    );
  }

  _icz8bdg4.InAppMessage message;

  int viewed;

  int tapped;

  /// Returns a shallow copy of this [InAppMessageListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InAppMessageListItem copyWith({
    _icz8bdg4.InAppMessage? message,
    int? viewed,
    int? tapped,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppMessageListItem',
      'message': message.toJson(),
      'viewed': viewed,
      'tapped': tapped,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InAppMessageListItem',
      'message': message.toJsonForProtocol(),
      'viewed': viewed,
      'tapped': tapped,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _InAppMessageListItemImpl extends InAppMessageListItem {
  _InAppMessageListItemImpl({
    required _icz8bdg4.InAppMessage message,
    required int viewed,
    required int tapped,
  }) : super._(
         message: message,
         viewed: viewed,
         tapped: tapped,
       );

  /// Returns a shallow copy of this [InAppMessageListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InAppMessageListItem copyWith({
    _icz8bdg4.InAppMessage? message,
    int? viewed,
    int? tapped,
  }) {
    return InAppMessageListItem(
      message: message ?? this.message.copyWith(),
      viewed: viewed ?? this.viewed,
      tapped: tapped ?? this.tapped,
    );
  }
}

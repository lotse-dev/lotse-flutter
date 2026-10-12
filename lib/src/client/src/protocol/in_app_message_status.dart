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

/// Lifecycle of an in-app message. Only a draft can be edited; an active
/// message is ended and created anew, so the report always belongs to one
/// fixed content.
enum InAppMessageStatus implements _isc.SerializableModel {
  draft,

  /// Delivered to the devices of its segment.
  active,

  /// Not delivered any more. Final.
  ended;

  static InAppMessageStatus fromJson(String name) {
    switch (name) {
      case 'draft':
        return InAppMessageStatus.draft;
      case 'active':
        return InAppMessageStatus.active;
      case 'ended':
        return InAppMessageStatus.ended;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "InAppMessageStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

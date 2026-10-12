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

/// How the cohorts of a RetentionReport split their installs.
enum RetentionSplit implements _isc.SerializableModel {
  /// By the campaign of the link the device is attributed to, with a part
  /// for organic devices.
  campaign,
  platform;

  static RetentionSplit fromJson(String name) {
    switch (name) {
      case 'campaign':
        return RetentionSplit.campaign;
      case 'platform':
        return RetentionSplit.platform;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "RetentionSplit"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

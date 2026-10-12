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

/// Result of one SetupCheck.
enum SetupCheckStatus implements _isc.SerializableModel {
  ok,

  /// Works, but something can make links open in the browser.
  warning,

  /// Links cannot open the app this way.
  failed,

  /// Could not be checked from the server, e.g. the manifest of the app.
  unknown;

  static SetupCheckStatus fromJson(String name) {
    switch (name) {
      case 'ok':
        return SetupCheckStatus.ok;
      case 'warning':
        return SetupCheckStatus.warning;
      case 'failed':
        return SetupCheckStatus.failed;
      case 'unknown':
        return SetupCheckStatus.unknown;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SetupCheckStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

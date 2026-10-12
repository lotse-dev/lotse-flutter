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

/// What an ExplorerSeries stands for.
enum ExplorerSeriesKind implements _isc.SerializableModel {
  /// A value of the split: prop value, platform, app version or campaign.
  /// ExplorerSeries.value null means the prop is not set, the version is
  /// unknown or the link has no campaign.
  value,

  /// Split by campaign: devices without an attributed link.
  organic,

  /// Split by platform, version or campaign: events without a device, such
  /// as link_click.
  noDevice,

  /// Everything beyond the largest series.
  other;

  static ExplorerSeriesKind fromJson(String name) {
    switch (name) {
      case 'value':
        return ExplorerSeriesKind.value;
      case 'organic':
        return ExplorerSeriesKind.organic;
      case 'noDevice':
        return ExplorerSeriesKind.noDevice;
      case 'other':
        return ExplorerSeriesKind.other;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ExplorerSeriesKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

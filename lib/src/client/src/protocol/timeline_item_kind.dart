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

/// What a TimelineItem stands for.
enum TimelineItemKind implements _isc.SerializableModel {
  /// The first start of the device, at device.firstSeenAt.
  install,

  /// A link click that deferred matching assigned to the device.
  click,

  /// The device was attributed to a link, at device.attributedAt.
  attribution,

  /// An event of the device, except those shown as their own kind.
  event,

  /// Feedback the device sent.
  feedback,

  /// A push of a campaign to the device.
  push;

  static TimelineItemKind fromJson(String name) {
    switch (name) {
      case 'install':
        return TimelineItemKind.install;
      case 'click':
        return TimelineItemKind.click;
      case 'attribution':
        return TimelineItemKind.attribution;
      case 'event':
        return TimelineItemKind.event;
      case 'feedback':
        return TimelineItemKind.feedback;
      case 'push':
        return TimelineItemKind.push;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TimelineItemKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

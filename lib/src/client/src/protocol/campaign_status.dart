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

/// Lifecycle of a push campaign.
enum CampaignStatus implements _isc.SerializableModel {
  /// Created, not handed to the worker yet.
  draft,

  /// Waits for campaign.sendAt; then it is sent like a draft. Back to draft
  /// when unscheduled, failed when it could not go out at that time.
  scheduled,

  /// Deliveries exist and the worker is working through them.
  sending,
  sent,

  /// Not a single delivery reached the provider.
  failed,

  /// A variant of a journey. Gets deliveries whenever the journey scanner
  /// decides devices; never sent, scheduled or finished as a whole.
  journey;

  static CampaignStatus fromJson(String name) {
    switch (name) {
      case 'draft':
        return CampaignStatus.draft;
      case 'scheduled':
        return CampaignStatus.scheduled;
      case 'sending':
        return CampaignStatus.sending;
      case 'sent':
        return CampaignStatus.sent;
      case 'failed':
        return CampaignStatus.failed;
      case 'journey':
        return CampaignStatus.journey;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CampaignStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

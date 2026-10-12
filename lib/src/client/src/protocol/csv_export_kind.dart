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

/// What AnalyticsEndpoint.exportCsv exports: one table or report of the
/// console. The setup tables (apps, API keys, members) are not exportable.
enum CsvExportKind implements _isc.SerializableModel {
  overview,
  acquisition,
  funnel,
  retention,
  explorer,

  /// Raw events in [from, to).
  events,
  devices,
  users,
  deviceTimeline,
  userTimeline,
  links,

  /// Clicks of one link, without IP hash and fingerprint.
  linkClicks,
  campaigns,

  /// Deliveries of one campaign.
  deliveries,
  campaignReport,

  /// The feedback inbox with its filters.
  feedback,
  featureBoard,

  /// In-app messages with their figures.
  inAppMessages,

  /// Answers of one survey with the filters of its answer list.
  surveyResponses,

  /// Journeys with their assigned devices.
  journeys,

  /// The groups of one journey.
  journeyReport;

  static CsvExportKind fromJson(String name) {
    switch (name) {
      case 'overview':
        return CsvExportKind.overview;
      case 'acquisition':
        return CsvExportKind.acquisition;
      case 'funnel':
        return CsvExportKind.funnel;
      case 'retention':
        return CsvExportKind.retention;
      case 'explorer':
        return CsvExportKind.explorer;
      case 'events':
        return CsvExportKind.events;
      case 'devices':
        return CsvExportKind.devices;
      case 'users':
        return CsvExportKind.users;
      case 'deviceTimeline':
        return CsvExportKind.deviceTimeline;
      case 'userTimeline':
        return CsvExportKind.userTimeline;
      case 'links':
        return CsvExportKind.links;
      case 'linkClicks':
        return CsvExportKind.linkClicks;
      case 'campaigns':
        return CsvExportKind.campaigns;
      case 'deliveries':
        return CsvExportKind.deliveries;
      case 'campaignReport':
        return CsvExportKind.campaignReport;
      case 'feedback':
        return CsvExportKind.feedback;
      case 'featureBoard':
        return CsvExportKind.featureBoard;
      case 'inAppMessages':
        return CsvExportKind.inAppMessages;
      case 'surveyResponses':
        return CsvExportKind.surveyResponses;
      case 'journeys':
        return CsvExportKind.journeys;
      case 'journeyReport':
        return CsvExportKind.journeyReport;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CsvExportKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

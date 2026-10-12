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

/// The three groups of an NPS answer: detractor 0 to 6, passive 7 and 8,
/// promoter 9 and 10. Used by the segment predicate surveyAnswer and the
/// filter of `AnalyticsEndpoint.surveyResponses`.
enum SurveyGroup implements _isc.SerializableModel {
  detractor,
  passive,
  promoter;

  static SurveyGroup fromJson(String name) {
    switch (name) {
      case 'detractor':
        return SurveyGroup.detractor;
      case 'passive':
        return SurveyGroup.passive;
      case 'promoter':
        return SurveyGroup.promoter;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SurveyGroup"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

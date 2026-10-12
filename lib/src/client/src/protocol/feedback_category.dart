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

/// What a feedback message is about, picked by the user in the sheet.
/// `question` is not in the sheet: it opens a support chat and is only
/// accepted while the project has the chat switched on.
enum FeedbackCategory implements _isc.SerializableModel {
  bug,
  idea,
  praise,
  other,
  question;

  static FeedbackCategory fromJson(String name) {
    switch (name) {
      case 'bug':
        return FeedbackCategory.bug;
      case 'idea':
        return FeedbackCategory.idea;
      case 'praise':
        return FeedbackCategory.praise;
      case 'other':
        return FeedbackCategory.other;
      case 'question':
        return FeedbackCategory.question;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "FeedbackCategory"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

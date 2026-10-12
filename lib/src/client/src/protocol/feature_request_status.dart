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

/// Where an idea stands on the feature board. There is no `submitted`: users
/// only vote on ideas the team created.
enum FeatureRequestStatus implements _isc.SerializableModel {
  open,
  planned,
  inProgress,
  shipped,
  archived;

  static FeatureRequestStatus fromJson(String name) {
    switch (name) {
      case 'open':
        return FeatureRequestStatus.open;
      case 'planned':
        return FeatureRequestStatus.planned;
      case 'inProgress':
        return FeatureRequestStatus.inProgress;
      case 'shipped':
        return FeatureRequestStatus.shipped;
      case 'archived':
        return FeatureRequestStatus.archived;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "FeatureRequestStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

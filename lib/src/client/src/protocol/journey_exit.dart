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

/// Why a device of a journey got no group and no push. Checked in this
/// order, before the assignment, so the groups stay comparable.
enum JourneyExit implements _isc.SerializableModel {
  /// Install trigger only: the device belongs to an app user older than
  /// the device, a new phone or a sign-in after reset(), not a new person.
  knownUser,

  /// The goal event came between the trigger and the decision.
  goalReached,

  /// The audience predicate did not match at the decision.
  notInAudience,

  /// No valid push token for a credential of the project.
  unreachable,

  /// The project's budget of journey decisions was used up.
  budget;

  static JourneyExit fromJson(String name) {
    switch (name) {
      case 'knownUser':
        return JourneyExit.knownUser;
      case 'goalReached':
        return JourneyExit.goalReached;
      case 'notInAudience':
        return JourneyExit.notInAudience;
      case 'unreachable':
        return JourneyExit.unreachable;
      case 'budget':
        return JourneyExit.budget;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "JourneyExit"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

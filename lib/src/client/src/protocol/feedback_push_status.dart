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

/// What became of the push that announces a team reply on the device.
enum FeedbackPushStatus implements _isc.SerializableModel {
  /// Handed to the worker, not answered by the provider yet.
  pending,
  sent,

  /// The project has no push credential. Not an error: the reply is still in
  /// the conversation.
  noCredential,

  /// The device is gone or has no valid token for a credential of the
  /// project. Not an error either.
  noToken,

  /// The provider rejected the token. Never retried.
  invalidToken,
  failed;

  static FeedbackPushStatus fromJson(String name) {
    switch (name) {
      case 'pending':
        return FeedbackPushStatus.pending;
      case 'sent':
        return FeedbackPushStatus.sent;
      case 'noCredential':
        return FeedbackPushStatus.noCredential;
      case 'noToken':
        return FeedbackPushStatus.noToken;
      case 'invalidToken':
        return FeedbackPushStatus.invalidToken;
      case 'failed':
        return FeedbackPushStatus.failed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "FeedbackPushStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

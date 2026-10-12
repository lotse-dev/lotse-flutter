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

/// How a device was matched to the link it came from.
enum AttributionSource implements _isc.SerializableModel {
  /// Exact: the Play Install Referrer carried the link's slug.
  referrer,

  /// Probabilistic: platform, language and IP prefix matched a recent click.
  fingerprint,

  /// The install referrer named a slug, but no open click of that link was
  /// there to back it. The app got its deep link; no campaign is credited
  /// (attributedLinkId stays null), since anyone can make up a referrer.
  referrerWithoutClick;

  static AttributionSource fromJson(String name) {
    switch (name) {
      case 'referrer':
        return AttributionSource.referrer;
      case 'fingerprint':
        return AttributionSource.fingerprint;
      case 'referrerWithoutClick':
        return AttributionSource.referrerWithoutClick;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AttributionSource"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

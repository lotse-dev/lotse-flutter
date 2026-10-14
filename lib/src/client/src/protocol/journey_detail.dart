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
import 'package:lotse/src/client/src/protocol/protocol.dart' as _ist2d7e6;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'campaign.dart' as _iv6aasei;
import 'journey.dart' as _iuh01ynj;

/// A journey as the console shows it: the journey, its variants and how many
/// devices were assigned to a group so far.
abstract class JourneyDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyDetail._({
    required this.journey,
    required this.variants,
    required this.assigned,
  });

  factory JourneyDetail({
    required _iuh01ynj.Journey journey,
    required List<_iv6aasei.Campaign> variants,
    required int assigned,
  }) = _JourneyDetailImpl;

  factory JourneyDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyDetail(
      journey: _ist2d7e6.Protocol().deserialize<_iuh01ynj.Journey>(
        jsonSerialization['journey'],
      ),
      variants: _ist2d7e6.Protocol().deserialize<List<_iv6aasei.Campaign>>(
        jsonSerialization['variants'],
      ),
      assigned: jsonSerialization['assigned'] as int,
    );
  }

  _iuh01ynj.Journey journey;

  /// The campaign of each variant, A first.
  List<_iv6aasei.Campaign> variants;

  /// Devices assigned to a group, the holdout included.
  int assigned;

  /// Returns a shallow copy of this [JourneyDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyDetail copyWith({
    _iuh01ynj.Journey? journey,
    List<_iv6aasei.Campaign>? variants,
    int? assigned,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyDetail',
      'journey': journey.toJson(),
      'variants': variants.toJson(valueToJson: (v) => v.toJson()),
      'assigned': assigned,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyDetail',
      'journey': journey.toJsonForProtocol(),
      'variants': variants.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'assigned': assigned,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _JourneyDetailImpl extends JourneyDetail {
  _JourneyDetailImpl({
    required _iuh01ynj.Journey journey,
    required List<_iv6aasei.Campaign> variants,
    required int assigned,
  }) : super._(journey: journey, variants: variants, assigned: assigned);

  /// Returns a shallow copy of this [JourneyDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyDetail copyWith({
    _iuh01ynj.Journey? journey,
    List<_iv6aasei.Campaign>? variants,
    int? assigned,
  }) {
    return JourneyDetail(
      journey: journey ?? this.journey.copyWith(),
      variants: variants ?? this.variants.map((e0) => e0.copyWith()).toList(),
      assigned: assigned ?? this.assigned,
    );
  }
}

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
import 'device_platform.dart' as _ij3iar7l;
import 'feedback.dart' as _iut2va9k;

/// One row of the feedback inbox.
abstract class FeedbackListItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackListItem._({
    required this.feedback,
    this.platform,
    this.campaign,
  });

  factory FeedbackListItem({
    required _iut2va9k.Feedback feedback,
    _ij3iar7l.DevicePlatform? platform,
    String? campaign,
  }) = _FeedbackListItemImpl;

  factory FeedbackListItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackListItem(
      feedback: _ist2d7e6.Protocol().deserialize<_iut2va9k.Feedback>(
        jsonSerialization['feedback'],
      ),
      platform: jsonSerialization['platform'] == null
          ? null
          : _ij3iar7l.DevicePlatform.fromJson(
              (jsonSerialization['platform'] as String),
            ),
      campaign: jsonSerialization['campaign'] as String?,
    );
  }

  _iut2va9k.Feedback feedback;

  /// Null when the device was deleted.
  _ij3iar7l.DevicePlatform? platform;

  /// Campaign of the link the device is attributed to.
  String? campaign;

  /// Returns a shallow copy of this [FeedbackListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackListItem copyWith({
    _iut2va9k.Feedback? feedback,
    _ij3iar7l.DevicePlatform? platform,
    String? campaign,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackListItem',
      'feedback': feedback.toJson(),
      if (platform != null) 'platform': platform?.toJson(),
      if (campaign != null) 'campaign': campaign,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackListItem',
      'feedback': feedback.toJsonForProtocol(),
      if (platform != null) 'platform': platform?.toJson(),
      if (campaign != null) 'campaign': campaign,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackListItemImpl extends FeedbackListItem {
  _FeedbackListItemImpl({
    required _iut2va9k.Feedback feedback,
    _ij3iar7l.DevicePlatform? platform,
    String? campaign,
  }) : super._(
         feedback: feedback,
         platform: platform,
         campaign: campaign,
       );

  /// Returns a shallow copy of this [FeedbackListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackListItem copyWith({
    _iut2va9k.Feedback? feedback,
    Object? platform = _Undefined,
    Object? campaign = _Undefined,
  }) {
    return FeedbackListItem(
      feedback: feedback ?? this.feedback.copyWith(),
      platform: platform is _ij3iar7l.DevicePlatform?
          ? platform
          : this.platform,
      campaign: campaign is String? ? campaign : this.campaign,
    );
  }
}

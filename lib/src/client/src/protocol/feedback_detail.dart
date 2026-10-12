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
import 'device.dart' as _ilo09f9g;
import 'event.dart' as _iu57571s;
import 'feedback.dart' as _iut2va9k;
import 'feedback_message.dart' as _i6m0uyvp;
import 'feedback_screenshot_info.dart' as _igoqmjz7;
import 'link.dart' as _iz3quwrh;

/// Everything the console shows for one feedback message.
abstract class FeedbackDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackDetail._({
    required this.feedback,
    this.device,
    this.attributedLink,
    required this.eventsBefore,
    required this.screenshots,
    required this.messages,
  });

  factory FeedbackDetail({
    required _iut2va9k.Feedback feedback,
    _ilo09f9g.Device? device,
    _iz3quwrh.Link? attributedLink,
    required List<_iu57571s.Event> eventsBefore,
    required List<_igoqmjz7.FeedbackScreenshotInfo> screenshots,
    required List<_i6m0uyvp.FeedbackMessage> messages,
  }) = _FeedbackDetailImpl;

  factory FeedbackDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackDetail(
      feedback: _ist2d7e6.Protocol().deserialize<_iut2va9k.Feedback>(
        jsonSerialization['feedback'],
      ),
      device: jsonSerialization['device'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      attributedLink: jsonSerialization['attributedLink'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_iz3quwrh.Link>(
              jsonSerialization['attributedLink'],
            ),
      eventsBefore: _ist2d7e6.Protocol().deserialize<List<_iu57571s.Event>>(
        jsonSerialization['eventsBefore'],
      ),
      screenshots: _ist2d7e6.Protocol()
          .deserialize<List<_igoqmjz7.FeedbackScreenshotInfo>>(
            jsonSerialization['screenshots'],
          ),
      messages: _ist2d7e6.Protocol()
          .deserialize<List<_i6m0uyvp.FeedbackMessage>>(
            jsonSerialization['messages'],
          ),
    );
  }

  _iut2va9k.Feedback feedback;

  /// Null when the device was deleted.
  _ilo09f9g.Device? device;

  /// Link the device is attributed to.
  _iz3quwrh.Link? attributedLink;

  /// What the device did before it sent the message, newest first.
  List<_iu57571s.Event> eventsBefore;

  List<_igoqmjz7.FeedbackScreenshotInfo> screenshots;

  /// The conversation below the message, oldest first.
  List<_i6m0uyvp.FeedbackMessage> messages;

  /// Returns a shallow copy of this [FeedbackDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackDetail copyWith({
    _iut2va9k.Feedback? feedback,
    _ilo09f9g.Device? device,
    _iz3quwrh.Link? attributedLink,
    List<_iu57571s.Event>? eventsBefore,
    List<_igoqmjz7.FeedbackScreenshotInfo>? screenshots,
    List<_i6m0uyvp.FeedbackMessage>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackDetail',
      'feedback': feedback.toJson(),
      if (device != null) 'device': device?.toJson(),
      if (attributedLink != null) 'attributedLink': attributedLink?.toJson(),
      'eventsBefore': eventsBefore.toJson(valueToJson: (v) => v.toJson()),
      'screenshots': screenshots.toJson(valueToJson: (v) => v.toJson()),
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackDetail',
      'feedback': feedback.toJsonForProtocol(),
      if (device != null) 'device': device?.toJsonForProtocol(),
      if (attributedLink != null)
        'attributedLink': attributedLink?.toJsonForProtocol(),
      'eventsBefore': eventsBefore.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'screenshots': screenshots.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'messages': messages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackDetailImpl extends FeedbackDetail {
  _FeedbackDetailImpl({
    required _iut2va9k.Feedback feedback,
    _ilo09f9g.Device? device,
    _iz3quwrh.Link? attributedLink,
    required List<_iu57571s.Event> eventsBefore,
    required List<_igoqmjz7.FeedbackScreenshotInfo> screenshots,
    required List<_i6m0uyvp.FeedbackMessage> messages,
  }) : super._(
         feedback: feedback,
         device: device,
         attributedLink: attributedLink,
         eventsBefore: eventsBefore,
         screenshots: screenshots,
         messages: messages,
       );

  /// Returns a shallow copy of this [FeedbackDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackDetail copyWith({
    _iut2va9k.Feedback? feedback,
    Object? device = _Undefined,
    Object? attributedLink = _Undefined,
    List<_iu57571s.Event>? eventsBefore,
    List<_igoqmjz7.FeedbackScreenshotInfo>? screenshots,
    List<_i6m0uyvp.FeedbackMessage>? messages,
  }) {
    return FeedbackDetail(
      feedback: feedback ?? this.feedback.copyWith(),
      device: device is _ilo09f9g.Device? ? device : this.device?.copyWith(),
      attributedLink: attributedLink is _iz3quwrh.Link?
          ? attributedLink
          : this.attributedLink?.copyWith(),
      eventsBefore:
          eventsBefore ?? this.eventsBefore.map((e0) => e0.copyWith()).toList(),
      screenshots:
          screenshots ?? this.screenshots.map((e0) => e0.copyWith()).toList(),
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}

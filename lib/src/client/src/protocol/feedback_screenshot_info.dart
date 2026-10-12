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

/// A screenshot without its bytes. The console fetches those one by one
/// through `getFeedbackScreenshot`.
abstract class FeedbackScreenshotInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackScreenshotInfo._({
    required this.id,
    required this.mimeType,
    required this.width,
    required this.height,
    required this.byteSize,
  });

  factory FeedbackScreenshotInfo({
    required int id,
    required String mimeType,
    required int width,
    required int height,
    required int byteSize,
  }) = _FeedbackScreenshotInfoImpl;

  factory FeedbackScreenshotInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FeedbackScreenshotInfo(
      id: jsonSerialization['id'] as int,
      mimeType: jsonSerialization['mimeType'] as String,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      byteSize: jsonSerialization['byteSize'] as int,
    );
  }

  int id;

  String mimeType;

  int width;

  int height;

  int byteSize;

  /// Returns a shallow copy of this [FeedbackScreenshotInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackScreenshotInfo copyWith({
    int? id,
    String? mimeType,
    int? width,
    int? height,
    int? byteSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackScreenshotInfo',
      'id': id,
      'mimeType': mimeType,
      'width': width,
      'height': height,
      'byteSize': byteSize,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackScreenshotInfo',
      'id': id,
      'mimeType': mimeType,
      'width': width,
      'height': height,
      'byteSize': byteSize,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _FeedbackScreenshotInfoImpl extends FeedbackScreenshotInfo {
  _FeedbackScreenshotInfoImpl({
    required int id,
    required String mimeType,
    required int width,
    required int height,
    required int byteSize,
  }) : super._(
         id: id,
         mimeType: mimeType,
         width: width,
         height: height,
         byteSize: byteSize,
       );

  /// Returns a shallow copy of this [FeedbackScreenshotInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackScreenshotInfo copyWith({
    int? id,
    String? mimeType,
    int? width,
    int? height,
    int? byteSize,
  }) {
    return FeedbackScreenshotInfo(
      id: id ?? this.id,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
      byteSize: byteSize ?? this.byteSize,
    );
  }
}

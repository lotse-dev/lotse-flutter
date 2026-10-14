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
import 'api_key.dart' as _i72lo5ui;

/// Returned once when a key pair is created. The secret is never shown again.
abstract class ApiKeyCreated
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ApiKeyCreated._({required this.apiKey, required this.secretKey});

  factory ApiKeyCreated({
    required _i72lo5ui.ApiKey apiKey,
    required String secretKey,
  }) = _ApiKeyCreatedImpl;

  factory ApiKeyCreated.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKeyCreated(
      apiKey: _ist2d7e6.Protocol().deserialize<_i72lo5ui.ApiKey>(
        jsonSerialization['apiKey'],
      ),
      secretKey: jsonSerialization['secretKey'] as String,
    );
  }

  _i72lo5ui.ApiKey apiKey;

  String secretKey;

  /// Returns a shallow copy of this [ApiKeyCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApiKeyCreated copyWith({_i72lo5ui.ApiKey? apiKey, String? secretKey});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiKeyCreated',
      'apiKey': apiKey.toJson(),
      'secretKey': secretKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiKeyCreated',
      'apiKey': apiKey.toJsonForProtocol(),
      'secretKey': secretKey,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ApiKeyCreatedImpl extends ApiKeyCreated {
  _ApiKeyCreatedImpl({
    required _i72lo5ui.ApiKey apiKey,
    required String secretKey,
  }) : super._(apiKey: apiKey, secretKey: secretKey);

  /// Returns a shallow copy of this [ApiKeyCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApiKeyCreated copyWith({_i72lo5ui.ApiKey? apiKey, String? secretKey}) {
    return ApiKeyCreated(
      apiKey: apiKey ?? this.apiKey.copyWith(),
      secretKey: secretKey ?? this.secretKey,
    );
  }
}

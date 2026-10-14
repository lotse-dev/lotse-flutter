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
import 'agent_token.dart' as _icvv29rr;

/// Returned once when an agent token is created. The token is never shown
/// again.
abstract class AgentTokenCreated
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AgentTokenCreated._({required this.agentToken, required this.token});

  factory AgentTokenCreated({
    required _icvv29rr.AgentToken agentToken,
    required String token,
  }) = _AgentTokenCreatedImpl;

  factory AgentTokenCreated.fromJson(Map<String, dynamic> jsonSerialization) {
    return AgentTokenCreated(
      agentToken: _ist2d7e6.Protocol().deserialize<_icvv29rr.AgentToken>(
        jsonSerialization['agentToken'],
      ),
      token: jsonSerialization['token'] as String,
    );
  }

  _icvv29rr.AgentToken agentToken;

  String token;

  /// Returns a shallow copy of this [AgentTokenCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AgentTokenCreated copyWith({_icvv29rr.AgentToken? agentToken, String? token});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AgentTokenCreated',
      'agentToken': agentToken.toJson(),
      'token': token,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AgentTokenCreated',
      'agentToken': agentToken.toJsonForProtocol(),
      'token': token,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AgentTokenCreatedImpl extends AgentTokenCreated {
  _AgentTokenCreatedImpl({
    required _icvv29rr.AgentToken agentToken,
    required String token,
  }) : super._(agentToken: agentToken, token: token);

  /// Returns a shallow copy of this [AgentTokenCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AgentTokenCreated copyWith({
    _icvv29rr.AgentToken? agentToken,
    String? token,
  }) {
    return AgentTokenCreated(
      agentToken: agentToken ?? this.agentToken.copyWith(),
      token: token ?? this.token,
    );
  }
}

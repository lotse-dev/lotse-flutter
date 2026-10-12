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

/// What an agent token may do, cumulative: `read` covers every read tool of
/// the MCP server; `write` adds the write tools only the team sees (segments,
/// the status of feedback and ideas); `publish` adds the tools that reach app
/// users or the public (replies to feedback, ideas on the board, links on the
/// link domain). See docs/MCP.md.
enum AgentTokenLevel implements _isc.SerializableModel {
  read,
  write,
  publish;

  static AgentTokenLevel fromJson(String name) {
    switch (name) {
      case 'read':
        return AgentTokenLevel.read;
      case 'write':
        return AgentTokenLevel.write;
      case 'publish':
        return AgentTokenLevel.publish;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AgentTokenLevel"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}

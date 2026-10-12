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
import 'explorer_split.dart' as _i6em6g0k;

/// What the event explorer counts, see AnalyticsEndpoint.explore.
abstract class ExplorerQuery
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExplorerQuery._({
    required this.event,
    this.propKey,
    this.propValue,
    this.split,
    this.splitProp,
  });

  factory ExplorerQuery({
    required String event,
    String? propKey,
    String? propValue,
    _i6em6g0k.ExplorerSplit? split,
    String? splitProp,
  }) = _ExplorerQueryImpl;

  factory ExplorerQuery.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExplorerQuery(
      event: jsonSerialization['event'] as String,
      propKey: jsonSerialization['propKey'] as String?,
      propValue: jsonSerialization['propValue'] as String?,
      split: jsonSerialization['split'] == null
          ? null
          : _i6em6g0k.ExplorerSplit.fromJson(
              (jsonSerialization['split'] as String),
            ),
      splitProp: jsonSerialization['splitProp'] as String?,
    );
  }

  /// Name of the event, 1 to 100 characters after trimming.
  String event;

  /// Optional filter: only events whose prop propKey equals propValue,
  /// compared exactly as tracked. Both or neither.
  String? propKey;

  String? propValue;

  /// Null for a single series.
  _i6em6g0k.ExplorerSplit? split;

  /// The prop to split by; required for ExplorerSplit.property, otherwise
  /// null.
  String? splitProp;

  /// Returns a shallow copy of this [ExplorerQuery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExplorerQuery copyWith({
    String? event,
    String? propKey,
    String? propValue,
    _i6em6g0k.ExplorerSplit? split,
    String? splitProp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExplorerQuery',
      'event': event,
      if (propKey != null) 'propKey': propKey,
      if (propValue != null) 'propValue': propValue,
      if (split != null) 'split': split?.toJson(),
      if (splitProp != null) 'splitProp': splitProp,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExplorerQuery',
      'event': event,
      if (propKey != null) 'propKey': propKey,
      if (propValue != null) 'propValue': propValue,
      if (split != null) 'split': split?.toJson(),
      if (splitProp != null) 'splitProp': splitProp,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExplorerQueryImpl extends ExplorerQuery {
  _ExplorerQueryImpl({
    required String event,
    String? propKey,
    String? propValue,
    _i6em6g0k.ExplorerSplit? split,
    String? splitProp,
  }) : super._(
         event: event,
         propKey: propKey,
         propValue: propValue,
         split: split,
         splitProp: splitProp,
       );

  /// Returns a shallow copy of this [ExplorerQuery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExplorerQuery copyWith({
    String? event,
    Object? propKey = _Undefined,
    Object? propValue = _Undefined,
    Object? split = _Undefined,
    Object? splitProp = _Undefined,
  }) {
    return ExplorerQuery(
      event: event ?? this.event,
      propKey: propKey is String? ? propKey : this.propKey,
      propValue: propValue is String? ? propValue : this.propValue,
      split: split is _i6em6g0k.ExplorerSplit? ? split : this.split,
      splitProp: splitProp is String? ? splitProp : this.splitProp,
    );
  }
}

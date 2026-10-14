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
import 'my_feedback.dart' as _ivxqciuj;
import 'my_feedback_message.dart' as _ikrc0jjp;

/// One feedback message of the device with its conversation, oldest first.
abstract class MyFeedbackThread
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyFeedbackThread._({required this.feedback, required this.messages});

  factory MyFeedbackThread({
    required _ivxqciuj.MyFeedback feedback,
    required List<_ikrc0jjp.MyFeedbackMessage> messages,
  }) = _MyFeedbackThreadImpl;

  factory MyFeedbackThread.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyFeedbackThread(
      feedback: _ist2d7e6.Protocol().deserialize<_ivxqciuj.MyFeedback>(
        jsonSerialization['feedback'],
      ),
      messages: _ist2d7e6.Protocol()
          .deserialize<List<_ikrc0jjp.MyFeedbackMessage>>(
            jsonSerialization['messages'],
          ),
    );
  }

  _ivxqciuj.MyFeedback feedback;

  List<_ikrc0jjp.MyFeedbackMessage> messages;

  /// Returns a shallow copy of this [MyFeedbackThread]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyFeedbackThread copyWith({
    _ivxqciuj.MyFeedback? feedback,
    List<_ikrc0jjp.MyFeedbackMessage>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyFeedbackThread',
      'feedback': feedback.toJson(),
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyFeedbackThread',
      'feedback': feedback.toJsonForProtocol(),
      'messages': messages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MyFeedbackThreadImpl extends MyFeedbackThread {
  _MyFeedbackThreadImpl({
    required _ivxqciuj.MyFeedback feedback,
    required List<_ikrc0jjp.MyFeedbackMessage> messages,
  }) : super._(feedback: feedback, messages: messages);

  /// Returns a shallow copy of this [MyFeedbackThread]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyFeedbackThread copyWith({
    _ivxqciuj.MyFeedback? feedback,
    List<_ikrc0jjp.MyFeedbackMessage>? messages,
  }) {
    return MyFeedbackThread(
      feedback: feedback ?? this.feedback.copyWith(),
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}

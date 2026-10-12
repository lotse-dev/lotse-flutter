import 'package:flutter/foundation.dart';

/// Writes a line of the SDK to the console of the app, prefixed `Lotse:`.
///
/// With [error], debug and profile builds get its whole text, release builds
/// only its type: `debugPrint` writes in release builds too, to logcat and
/// the iOS log, where an exception text could carry a server answer or a
/// value of the host app (audit 025 I5).
void lotseLog(String message, [Object? error]) {
  final String line;
  if (error == null) {
    line = message;
  } else if (kReleaseMode) {
    line = '$message: ${error.runtimeType}';
  } else {
    line = '$message: $error';
  }
  debugPrint('Lotse: $line');
}

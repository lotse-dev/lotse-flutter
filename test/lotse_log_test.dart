import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_log.dart';

void main() {
  late List<String?> printed;
  late DebugPrintCallback original;

  setUp(() {
    printed = [];
    original = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message);
  });

  tearDown(() => debugPrint = original);

  test('a line without an error is prefixed', () {
    lotseLog('the tap budget is used up.');
    expect(printed, ['Lotse: the tap budget is used up.']);
  });

  test('outside release builds the error goes along in full', () {
    // Tests never run in release mode; there only the type is written.
    expect(kReleaseMode, isFalse);
    lotseLog('could not track "x"', StateError('details'));
    expect(printed, ['Lotse: could not track "x": Bad state: details']);
  });
}

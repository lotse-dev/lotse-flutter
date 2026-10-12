import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';

void main() {
  test('instance throws before init', () {
    expect(() => Lotse.instance, throwsStateError);
  });
}

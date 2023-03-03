import 'package:obp2_runtime/obp2_runtime.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = 42;

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome, 42);
    });
  });
}

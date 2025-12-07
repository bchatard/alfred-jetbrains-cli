import 'package:alfred_jetbrains_cli/exception/not_found.dart';
import 'package:test/test.dart';

void main() {
  group('NotFoundException', () {
    test('constructor with message only', () {
      final exception = NotFoundException(message: 'Not found');
      expect(exception.message, 'Not found');
      expect(exception.troubleshoot, isNull);
    });

    test('constructor with message and troubleshoot', () {
      final exception = NotFoundException(
        message: 'Not found',
        troubleshoot: 'Check the path',
      );
      expect(exception.message, 'Not found');
      expect(exception.troubleshoot, 'Check the path');
    });

    test('implements Exception', () {
      final exception = NotFoundException(message: 'test');
      expect(exception, isA<Exception>());
    });
  });
}

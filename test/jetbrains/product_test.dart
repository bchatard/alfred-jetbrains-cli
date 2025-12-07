import 'package:alfred_jetbrains_cli/jetbrains/product.dart';
import 'package:test/test.dart';

void main() {
  group('JetBrainsProduct', () {
    test('values.byName returns correct product', () {
      expect(
        JetBrainsProduct.values.byName('phpStorm'),
        JetBrainsProduct.phpStorm,
      );
    });

    test('all products are defined', () {
      expect(JetBrainsProduct.values.length, 19);
    });

    test('contains expected products', () {
      final productNames = JetBrainsProduct.values.map((p) => p.name).toList();
      expect(productNames, contains('androidStudio'));
      expect(productNames, contains('intelliJIdeaUltimate'));
      expect(productNames, contains('phpStorm'));
      expect(productNames, contains('webStorm'));
      expect(productNames, contains('fleet'));
    });
  });

  group('JetBrainsProductString extension', () {
    test('toJbName converts camelCase to proper name', () {
      expect('phpStorm'.toJbName(), 'PhpStorm');
      expect('webStorm'.toJbName(), 'WebStorm');
      expect('androidStudio'.toJbName(), 'AndroidStudio');
    });

    test('toJbName capitalizes first character always', () {
      // Note: toJbName capitalizes first lowercase char it encounters
      // 'PhpStorm' -> 'P' is uppercase so capitalizeNext stays true, 'h' gets capitalized
      expect('PhpStorm'.toJbName(), 'PHpStorm');
      expect('PHPSTORM'.toJbName(), 'PHPSTORM');
    });

    test('toJbName handles strings with spaces', () {
      expect('hello world'.toJbName(), 'Hello World');
    });

    test('toJbName handles strings with periods', () {
      expect('hello.world'.toJbName(), 'Hello.World');
    });

    test('toJbName handles empty string', () {
      expect(''.toJbName(), '');
    });

    test('toJbName handles single character', () {
      expect('a'.toJbName(), 'A');
      expect('A'.toJbName(), 'A');
    });
  });
}

import 'package:alfred_jetbrains_cli/jetbrains/product.dart';
import 'package:test/test.dart';

void main() {
  test('Product', () {
    expect(
      JetBrainsProduct.values.byName('phpStorm'),
      JetBrainsProduct.phpStorm,
    );
  });
}

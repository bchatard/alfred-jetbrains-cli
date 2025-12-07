import 'package:alfred_jetbrains_cli/jetbrains/product.dart';
import 'package:alfred_jetbrains_cli/jetbrains/product_config.dart';
import 'package:alfred_jetbrains_cli/jetbrains/product_details.dart';
import 'package:test/test.dart';

void main() {
  group('JetBrainsProductDetails', () {
    test('constructor and properties', () {
      final details = JetBrainsProductDetails(
        applicationNames: ['PhpStorm'],
        preferencePrefix: 'PhpStorm',
        binaries: ['phpstorm', 'pstorm'],
      );
      expect(details.applicationNames, ['PhpStorm']);
      expect(details.preferencePrefix, 'PhpStorm');
      expect(details.binaries, ['phpstorm', 'pstorm']);
    });

    test('toJson serializes correctly', () {
      final details = JetBrainsProductDetails(
        applicationNames: ['App1', 'App2'],
        preferencePrefix: 'Prefix',
        binaries: ['bin1'],
      );
      final json = details.toJson();
      expect(json['applicationNames'], ['App1', 'App2']);
      expect(json['preferencePrefix'], 'Prefix');
      expect(json['binaries'], ['bin1']);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'applicationNames': ['TestApp'],
        'preferencePrefix': 'TestPrefix',
        'binaries': ['testbin'],
      };
      final details = JetBrainsProductDetails.fromJson(json);
      expect(details.applicationNames, ['TestApp']);
      expect(details.preferencePrefix, 'TestPrefix');
      expect(details.binaries, ['testbin']);
    });

    test('toString returns json string', () {
      final details = JetBrainsProductDetails(
        applicationNames: ['App'],
        preferencePrefix: 'Pref',
        binaries: ['bin'],
      );
      expect(details.toString(), contains('applicationNames'));
    });
  });

  group('JetBrainsProductsDetails', () {
    test('constructor and properties', () {
      final config = {
        JetBrainsProduct.phpStorm: JetBrainsProductDetails(
          applicationNames: ['PhpStorm'],
          preferencePrefix: 'PhpStorm',
          binaries: ['phpstorm'],
        ),
      };
      final productsDetails = JetBrainsProductsDetails(config: config);
      expect(productsDetails.config.length, 1);
      expect(
        productsDetails.config.containsKey(JetBrainsProduct.phpStorm),
        isTrue,
      );
    });
  });

  group('JetBrainsProductConfiguration', () {
    test('defaultConfig returns all products', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(config.length, 19);
    });

    test('defaultConfig contains phpStorm configuration', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(config.containsKey(JetBrainsProduct.phpStorm), isTrue);
      final phpStorm = config[JetBrainsProduct.phpStorm]!;
      expect(phpStorm.applicationNames, contains('PhpStorm'));
      expect(phpStorm.preferencePrefix, 'PhpStorm');
      expect(phpStorm.binaries, contains('phpstorm'));
    });

    test('defaultConfig contains webStorm configuration', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(config.containsKey(JetBrainsProduct.webStorm), isTrue);
      final webStorm = config[JetBrainsProduct.webStorm]!;
      expect(webStorm.applicationNames, contains('WebStorm'));
      expect(webStorm.binaries, contains('webstorm'));
      expect(webStorm.binaries, contains('wstorm'));
    });

    test('defaultConfig contains intelliJ configurations', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(
        config.containsKey(JetBrainsProduct.intelliJIdeaCommunity),
        isTrue,
      );
      expect(config.containsKey(JetBrainsProduct.intelliJIdeaUltimate), isTrue);
    });

    test('defaultConfig contains androidStudio configuration', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(config.containsKey(JetBrainsProduct.androidStudio), isTrue);
      final androidStudio = config[JetBrainsProduct.androidStudio]!;
      expect(androidStudio.applicationNames, contains('Android Studio'));
      expect(androidStudio.preferencePrefix, 'AndroidStudio');
    });

    test('defaultConfig contains fleet configuration', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      expect(config.containsKey(JetBrainsProduct.fleet), isTrue);
      final fleet = config[JetBrainsProduct.fleet]!;
      expect(fleet.applicationNames, contains('Fleet'));
    });

    test('defaultConfig PyCharm has both community and professional', () {
      final config = JetBrainsProductConfiguration.defaultConfig();
      final pyCharmPro = config[JetBrainsProduct.pyCharmProfessional]!;
      final pyCharmCE = config[JetBrainsProduct.pyCharmCommunity]!;
      expect(pyCharmPro.preferencePrefix, 'PyCharm');
      expect(pyCharmCE.preferencePrefix, 'PyCharmCE');
    });
  });
}

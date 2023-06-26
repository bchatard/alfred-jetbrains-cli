import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../exception/not_found.dart';
import '../logger.dart';
import 'jetbrains.dart';

class JetBrainsProductConfiguration {
  static JetBrainsProductsDetails? _config;

  static JetBrainsProductsDetails config() {
    if (_config == null) {
      final Map<String, String> env = Platform.environment;
      final Map<String, dynamic> customConfig =
          json.decode(env['jb_custom_config'] ?? '{}');
      logger.i('Custom Config: $customConfig');

      _config = _mergeConfig(customConfig);
    }
    return _config!;
  }

  static JetBrainsProductDetails productConfig(JetBrainsProduct product) {
    if (config().config.containsKey(product)) {
      return config()
          .config
          .entries
          .singleWhere((element) => element.key == product)
          .value;
    }
    throw NotFoundException(
      message: "Can't find product configuration. This should never happen.",
    );
  }

  static JetBrainsProductsDetails _mergeConfig(
      Map<String, dynamic> customConfig) {
    final Map<String, dynamic> myConfig =
        JetBrainsProductConfiguration.defaultConfig()
            .map((defaultKey, defaultValue) {
      // custom config contain an existing product
      if (customConfig.containsKey(defaultKey.name)) {
        final Map<String, dynamic> customConfigValue =
            customConfig[defaultKey.name];
        //
        final Map<String, dynamic> value =
            defaultValue.toJson().map((detailKey, detailValue) {
          if (customConfigValue[detailKey] != null) {
            return MapEntry(detailKey, customConfigValue[detailKey]);
          }
          return MapEntry(detailKey, detailValue);
        });
        // put override value
        return MapEntry(defaultKey.name, value);
      }
      // keep default value
      return MapEntry(defaultKey.name, defaultValue.toJson());
    });

    try {
      return JetBrainsProductsDetails.fromJson({"config": myConfig});
    } catch (e) {
      logger.e(e);
      throw UsageException('Your configuration is not valid.',
          'Please check the documentation, and fix your configuration.');
    }
  }

  static JetBrainsProductsConfig defaultConfig() {
    return {
      JetBrainsProduct.androidStudio: JetBrainsProductDetails(
        applicationNames: [
          'Android Studio',
        ],
        preferencePrefix: 'AndroidStudio',
        binaries: [
          'studio',
        ],
      ),
      JetBrainsProduct.appCode: JetBrainsProductDetails(
        applicationNames: [
          'AppCode',
        ],
        preferencePrefix: 'AppCode',
        binaries: [
          'appcode',
        ],
      ),
      JetBrainsProduct.aqua: JetBrainsProductDetails(
        applicationNames: [
          'Aqua',
        ],
        preferencePrefix: 'Aqua',
        binaries: [
          'aqua',
        ],
      ),
      JetBrainsProduct.cLion: JetBrainsProductDetails(
        applicationNames: [
          'CLion',
        ],
        preferencePrefix: 'CLion',
        binaries: [
          'clion',
        ],
      ),
      JetBrainsProduct.dataGrip: JetBrainsProductDetails(
        applicationNames: [
          'DataGrip',
        ],
        preferencePrefix: 'DataGrip',
        binaries: [
          'datagrip',
        ],
      ),
      JetBrainsProduct.dataSpell: JetBrainsProductDetails(
        applicationNames: [
          'DataSpell',
        ],
        preferencePrefix: 'DataSpell',
        binaries: [
          'dataspell',
        ],
      ),
      JetBrainsProduct.fleet: JetBrainsProductDetails(
        applicationNames: [
          'Fleet',
        ],
        preferencePrefix: 'Fleet',
        binaries: [
          'fleet',
        ],
      ),
      // JetBrainsProduct.gateway: JetBrainsProductDetails(
      //   applicationNames: [
      //     'Gateway',
      //   ],
      //   preferencePrefix: 'JetBrainsGateway',
      //   binaries: [
      //     'gateway',
      //   ],
      // ),
      JetBrainsProduct.goLand: JetBrainsProductDetails(
        applicationNames: [
          'GoLand',
        ],
        preferencePrefix: 'GoLand',
        binaries: [
          'goland',
        ],
      ),
      JetBrainsProduct.intelliJIdeaCommunity: JetBrainsProductDetails(
        applicationNames: [
          'IntelliJ IDEA CE',
          'IntelliJ IDEA Community',
          'IntelliJ IDEA Community Edition',
        ],
        preferencePrefix: 'IdeaIC',
        binaries: [
          'idea',
          'ideac',
        ],
      ),
      JetBrainsProduct.intelliJIdeaUltimate: JetBrainsProductDetails(
        applicationNames: [
          'IntelliJ IDEA',
          'IntelliJ IDEA Ultimate',
          'IntelliJ IDEA Ultimate Edition',
        ],
        preferencePrefix: 'IntelliJIdea',
        binaries: [
          'idea',
          'ideau',
        ],
      ),
      JetBrainsProduct.phpStorm: JetBrainsProductDetails(
        applicationNames: [
          'PhpStorm',
        ],
        preferencePrefix: 'PhpStorm',
        binaries: [
          'phpstorm',
          'pstorm',
        ],
      ),
      JetBrainsProduct.pyCharmProfessional: JetBrainsProductDetails(
        applicationNames: [
          'PyCharm',
          'PyCharm Professional',
          'PyCharm Professional',
          'PyCharm Professional Edition',
        ],
        preferencePrefix: 'PyCharm',
        binaries: [
          'pycharm',
          'charm',
          'pycharmp',
          'charmp',
        ],
      ),
      JetBrainsProduct.pyCharmCommunity: JetBrainsProductDetails(
        applicationNames: [
          'PyCharm CE',
          'PyCharm Community',
          'PyCharm Community Edition',
        ],
        preferencePrefix: 'PyCharmCE',
        binaries: [
          'pycharm',
          'charm',
          'pycharmc',
          'charmc',
        ],
      ),
      JetBrainsProduct.rider: JetBrainsProductDetails(
        applicationNames: [
          'Rider',
        ],
        preferencePrefix: 'Rider',
        binaries: [
          'rider',
        ],
      ),
      JetBrainsProduct.rubyMine: JetBrainsProductDetails(
        applicationNames: [
          'RubyMine',
        ],
        preferencePrefix: 'RubyMine',
        binaries: [
          'rubymine',
          'mine',
        ],
      ),
      JetBrainsProduct.webStorm: JetBrainsProductDetails(
        applicationNames: [
          'WebStorm',
        ],
        preferencePrefix: 'WebStorm',
        binaries: [
          'webstorm',
          'wstorm',
        ],
      ),
    };
  }
}

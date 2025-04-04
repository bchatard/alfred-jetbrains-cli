import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart';

import '../exception/not_found.dart';
import '../helper.dart';
import '../logger.dart';
import 'jetbrains.dart';

class JetBrainsProjects {
  final JetBrainsProduct product;

  static final List<String> _settingsPath = [
    '~/Library/Application Support/Google',
    '~/Library/Application Support/JetBrains',
    '~/Library/Preferences',
  ];

  JetBrainsProjects(this.product);

  static List<String> _getSettingsPath() {
    final Map<String, String> env = Platform.environment;
    final jbSettings = env['jb_settings'] ?? '';
    return jbSettings.isEmpty ? _settingsPath : jbSettings.split(':');
  }

  FileSystemEntity locateSettingsDirectory() {
    final productName = product.name.toJbName();
    logger.i("Locate Settings Directory for ${product.name}");
    final productConfig = JetBrainsProductConfiguration.productConfig(product);
    final paths = _getSettingsPath();
    logger.i("Search in $paths");
    for (var path in paths) {
      final Directory appSupport = Directory(parsePath(path));
      logger.i("Looking in $appSupport");
      if (!appSupport.existsSync()) {
        logger.e("$appSupport doesn't exists");
        throw FileSystemException(
          "Settings path doesn't exists",
          appSupport.absolute.path,
        );
      }

      logger.i(
        "Application Support: ${appSupport.absolute.path}/${productConfig.preferencePrefix}",
      );
      // Fleet preferences directory doesn't contains version
      // maybe this will change with stable release
      final prefPattern =
          (product == JetBrainsProduct.fleet)
              ? RegExp(productConfig.preferencePrefix)
              : RegExp(
                "${productConfig.preferencePrefix}((\\d|\\d{4})\\.\\d\$)",
              );
      List<FileSystemEntity> availablePaths =
          appSupport
              .listSync(recursive: false, followLinks: true)
              .where(
                (FileSystemEntity event) =>
                    FileSystemEntity.isDirectorySync(event.absolute.path) &&
                    prefPattern.hasMatch(basename(event.absolute.path)),
              )
              .toList()
            ..sort((FileSystemEntity a, FileSystemEntity b) {
              final String aVersion =
                  prefPattern.allMatches(a.path).first.group(1).toString();
              final String bVersion =
                  prefPattern.allMatches(b.path).first.group(1).toString();
              return bVersion.compareTo(aVersion);
            });

      if (availablePaths.isNotEmpty) {
        logger.i("Settings Paths: $availablePaths");
        for (FileSystemEntity availablePath in availablePaths) {
          final Directory settingsPath = Directory(
            parsePath(availablePath.absolute.path),
          );
          if (settingsPath
                  .listSync(recursive: false, followLinks: false)
                  .length >
              1) {
            logger.i("Use ${settingsPath.absolute.path}");
            return settingsPath;
          }
        }
      }
    }

    logger.e("Can't find settings path for $productName");

    throw NotFoundException(
      message: "Can't find settings path for $productName",
      troubleshoot:
          "Please check if preferences '${productConfig.preferencePrefix}' exists in $paths",
    );
  }

  Iterable<String> retrieveRecentProjects() {
    final FileSystemEntity settingsPath = locateSettingsDirectory();
    final String optionsPath = join(settingsPath.absolute.path, 'options');

    final File recentProjectDirectories = File(
      join(optionsPath, 'recentProjectDirectories.xml'),
    );
    if (recentProjectDirectories.existsSync()) {
      logger.i("Use recentProjectDirectories.xml");
      return JetBrainsProjectsExtractor.recentProjectDirectoriesExtractor(
        recentProjectDirectories,
      );
    }

    final File recentProjects = File(join(optionsPath, 'recentProjects.xml'));
    if (recentProjects.existsSync()) {
      logger.i("Use recentProjects.xml");
      return JetBrainsProjectsExtractor.recentProjectsExtractor(recentProjects);
    }

    final File recentSolutions = File(join(optionsPath, 'recentSolutions.xml'));
    if (recentSolutions.existsSync()) {
      logger.i("Use recentSolutions.xml");
      return JetBrainsProjectsExtractor.recentSolutionsExtractor(
        recentSolutions,
      );
    }

    if (product == JetBrainsProduct.fleet) {
      return _retrieveFleetProjects(settingsPath);
    }

    return [];
  }

  Iterable<String> _retrieveFleetProjects(FileSystemEntity settingsPath) {
    final List<FileSystemEntity> files =
        Glob(
          join(settingsPath.absolute.path, 'backend/**/trusted-paths.xml'),
        ).listSync();
    final List<String> paths = [];
    for (var file in files) {
      paths.addAll(
        JetBrainsProjectsExtractor.trustedPathsExtractor(
          File(file.absolute.path),
        ),
      );
    }
    return paths;
  }
}

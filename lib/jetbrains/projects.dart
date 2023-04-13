import 'dart:io';

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
    final productConfig = JetBrainsProductConfiguration.productConfig(product);
    final paths = _getSettingsPath();
    for (var path in paths) {
      final Directory appSupport = Directory(parsePath(path));
      if (!appSupport.existsSync()) {
        throw FileSystemException(
          "Settings path doesn't exists",
          appSupport.absolute.path,
        );
      }

      logger.i(
          "Application Support: ${appSupport.absolute.path}/${productConfig.preferencePrefix}");
      final r =
          RegExp("${productConfig.preferencePrefix}((\\d|\\d{4})\\.\\d\$)");
      List<FileSystemEntity> availablePaths = appSupport
          .listSync(recursive: false, followLinks: true)
          .where((FileSystemEntity event) =>
              FileSystemEntity.isDirectorySync(event.absolute.path) &&
              r.hasMatch(basename(event.absolute.path)))
          .toList()
        ..sort((FileSystemEntity a, FileSystemEntity b) {
          final String aVersion =
              r.allMatches(a.path).first.group(1).toString();
          final String bVersion =
              r.allMatches(b.path).first.group(1).toString();
          return bVersion.compareTo(aVersion);
        });

      if (availablePaths.isNotEmpty) {
        logger.i(availablePaths.toString());
        return availablePaths.first;
      }
    }
    throw NotFoundException(
      message: "Can't find settings path for $productName",
      troubleshoot:
          "Please check if preferences '${productConfig.preferencePrefix}' exists in $paths",
    );
  }

  Iterable<String> retrieveRecentProjects() {
    final FileSystemEntity settingsPath = locateSettingsDirectory();
    final String optionsPath = join(settingsPath.absolute.path, 'options');

    final File recentProjectDirectories =
        File(join(optionsPath, 'recentProjectDirectories.xml'));
    if (recentProjectDirectories.existsSync()) {
      logger.i("Use recentProjectDirectories.xml");
      return JetBrainsProjectsExtractor.recentProjectDirectoriesExtractor(
          recentProjectDirectories);
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
          recentSolutions);
    }

    return [];
  }
}

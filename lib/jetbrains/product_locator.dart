import 'dart:io';

import 'package:alfred_jetbrains_cli/exception/not_found.dart';
import 'package:alfred_jetbrains_cli/helper.dart';
import 'package:alfred_jetbrains_cli/jetbrains/jetbrains.dart';
import 'package:alfred_jetbrains_cli/logger.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';

class JetBrainsProductLocator {
  FileSystemEntity? _bin;
  FileSystemEntity? _application;
  final JetBrainsProduct product;

  static final List<String> _applicationPath = [
    '/Applications',
    '~/Applications',
    '~/Applications/JetBrains Toolbox',
  ];

  JetBrainsProductLocator(this.product);

  FileSystemEntity locateBin() {
    if (_bin != null) {
      return _bin!;
    }
    logger.i("Locate Bin for ${product.name.toJbName()}");
    final Map<String, String> env = Platform.environment;
    final jbBinaries = env['jb_binaries'] ?? '';
    final List<String> paths = (jbBinaries.isEmpty ? env['PATH']! : jbBinaries)
        .split(':');
    final JetBrainsProductDetails productConfig =
        JetBrainsProductConfiguration.productConfig(product);
    final List<String> binaries = productConfig.binaries;

    // since 2023, bin script are no more generated for dmg installation
    paths.add(join(locateApplication().absolute.path, 'Contents', 'MacOS'));

    logger.i("Search in $paths");
    logger.i("Search binaries $binaries");

    for (var path in paths) {
      final binPath = Directory(parsePath(path));
      logger.i("Looking in $binPath");
      if (!binPath.existsSync()) {
        logger.i("$binPath doesn't exists");
        continue;
      }
      final FileSystemEntity? bin = binPath.listSync().singleWhereOrNull((
        file,
      ) {
        final binName = basename(file.absolute.path);
        logger.i("Check binary $binName");
        return binaries.contains(binName);
      });

      if (bin != null) {
        _bin = bin;
        logger.i("Use binary $bin");
        return bin;
      }
    }

    logger.e("Can't locate bin for ${product.name}");

    throw NotFoundException(
      message: "Can't locate bin for ${product.name}",
      troubleshoot: "Please check if binaries ($binaries) exists in $paths",
    );
  }

  FileSystemEntity locateApplication() {
    if (_application != null) {
      return _application!;
    }
    logger.i("Locate Application for ${product.name.toJbName()}");
    final Map<String, String> env = Platform.environment;
    final jbApplications = env['jb_application'] ?? '';
    final List<String> paths = jbApplications.isEmpty
        ? _applicationPath
        : jbApplications.split(':');
    final JetBrainsProductDetails productConfig =
        JetBrainsProductConfiguration.productConfig(product);

    logger.i("Search in $paths");
    logger.i("Search applications ${productConfig.applicationNames}");

    for (var path in paths) {
      final appPath = Directory(parsePath(path));
      logger.i("Looking in $appPath");
      if (!appPath.existsSync()) {
        logger.i("$appPath doesn't exists");
        continue;
      }
      final FileSystemEntity? app = appPath.listSync().singleWhereOrNull((
        file,
      ) {
        String basePath = basenameWithoutExtension(file.absolute.path);
        logger.i("Check application $basePath");
        return productConfig.applicationNames.singleWhereOrNull(
              (appName) => appName == basePath,
            ) !=
            null;
      });

      if (app != null) {
        _application = app;
        logger.i("Use application $app");
        return app;
      }
    }

    logger.e("Can't locate application for ${product.name}");

    throw NotFoundException(
      message: "Can't locate application for ${product.name}",
      troubleshoot:
          "Please check if application '${productConfig.applicationNames}' exists in $paths",
    );
  }
}

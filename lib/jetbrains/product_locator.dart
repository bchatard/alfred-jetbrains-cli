import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';

import '../exception/not_found.dart';
import '../helper.dart';
import 'jetbrains.dart';

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
    final Map<String, String> env = Platform.environment;
    final jbBinaries = env['jb_binaries'] ?? '';
    final List<String> paths =
        (jbBinaries.isEmpty ? env['PATH']! : jbBinaries).split(':');
    final JetBrainsProductDetails productConfig =
        JetBrainsProductConfiguration.productConfig(product);
    final List<String> binaries = productConfig.binaries;

    // since 2023, bin script are no more generated for dmg installation
    paths.add(join(locateApplication().absolute.path, 'Contents', 'MacOS'));

    for (var path in paths) {
      final binPath = Directory(parsePath(path));
      if (!binPath.existsSync()) {
        continue;
      }
      final FileSystemEntity? bin = binPath.listSync().singleWhereOrNull(
          (file) => binaries.contains(basename(file.absolute.path)));

      if (bin != null) {
        _bin = bin;
        return bin;
      }
    }

    throw NotFoundException(
      message: "Can't locate bin for ${product.name}",
      troubleshoot: "Please check if binaries ($binaries) exists in $paths",
    );
  }

  FileSystemEntity locateApplication() {
    if (_application != null) {
      return _application!;
    }
    final Map<String, String> env = Platform.environment;
    final jbApplications = env['jb_application'] ?? '';
    final List<String> paths =
        jbApplications.isEmpty ? _applicationPath : jbApplications.split(':');
    final JetBrainsProductDetails productConfig =
        JetBrainsProductConfiguration.productConfig(product);
    for (var path in paths) {
      final appPath = Directory(parsePath(path));
      if (!appPath.existsSync()) {
        continue;
      }
      final FileSystemEntity? app = appPath.listSync().singleWhereOrNull(
          (file) =>
              basenameWithoutExtension(file.absolute.path) ==
              productConfig.applicationName);

      if (app != null) {
        _application = app;
        return app;
      }
    }

    throw NotFoundException(
      message: "Can't locate application for ${product.name}",
      troubleshoot:
          "Please check if application '${productConfig.applicationName}' exists in $paths",
    );
  }
}

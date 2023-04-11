import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';

import '../exception/not_found_exception.dart';
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
    for (var path in paths) {
      final FileSystemEntity? bin = Directory(_parsePath(path))
          .listSync()
          .singleWhereOrNull(
              (file) => binaries.contains(basename(file.absolute.path)));

      if (bin != null) {
        _bin = bin;
        return bin;
      }
    }

    throw NotFoundException("Can't locate bin for ${product.name}");
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
      final FileSystemEntity? app = Directory(_parsePath(path))
          .listSync()
          .singleWhereOrNull((file) =>
              basenameWithoutExtension(file.absolute.path) ==
              productConfig.applicationName);

      if (app != null) {
        _application = app;
        return app;
      }
    }

    throw NotFoundException("Can't locate application for ${product.name}");
  }

  String _parsePath(String path) {
    if (path.contains('~')) {
      return path.replaceAll('~', Platform.environment['HOME']!);
    }
    return path;
  }
}

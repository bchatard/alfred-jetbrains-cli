import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';

import '../alfred/alfred.dart';
import '../jetbrains/jetbrains.dart';
import '../logger.dart';

class SearchCommand extends Command<int> {
  @override
  String get description => 'Search projects for a JetBrains product';

  @override
  String get name => 'search';

  SearchCommand() {
    final allowedProducts = <String, String>{};
    for (var product in [...JetBrainsProduct.values]
      ..sort(Enum.compareByName)) {
      allowedProducts[product.name] = product.name.toJbName();
    }

    argParser
      ..addOption(
        'product',
        help: 'JetBrains product',
        mandatory: true,
        allowedHelp: allowedProducts,
        allowed: allowedProducts.keys,
      )
      ..addOption(
        'filter',
        help: 'Filter projects',
      );
  }

  @override
  FutureOr<int>? run() async {
    final JetBrainsProduct product =
        JetBrainsProduct.values.byName(argResults!['product']);
    String filter = argResults!['filter'] ?? '';
    filter = filter.toLowerCase();
    final response = AlfredResponse();

    logger.i(
        "Search project for ${product.name.toJbName()} with filter '$filter'");

    final jbProduct = JetBrainsProductLocator(product);
    final jbProjects = JetBrainsProjects(product);

    final Iterable<String> projects = jbProjects.retrieveRecentProjects();

    Iterable<ResultItem> items = projects.map((projectPath) {
      final JetBrainsProjectName project = JetBrainsProjectName(projectPath);

      return ResultItemBuilder(
        name: project.name,
        path: projectPath,
        iconPath: jbProduct.locateApplication().absolute.path,
        binPath: jbProduct.locateBin().absolute.path,
      ).build();
    });

    if (filter.isNotEmpty) {
      items = items.where((ResultItem item) {
        if (item.title.toLowerCase().contains(filter) ||
            (item.variables != null &&
                item.variables!.jbSearchBasename
                    .toLowerCase()
                    .contains(filter))) {
          return true;
        }
        return false;
      });
    }

    response.render(items.toList());

    return ExitCode.success.code;
  }
}

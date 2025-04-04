import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';

import '../alfred/alfred.dart';
import '../jetbrains/jetbrains.dart';
import '../logger.dart';

class SearchAllCommand extends Command<int> {
  @override
  String get description => 'Search projects for all JetBrains product';

  @override
  String get name => 'all';

  SearchAllCommand() {
    final allowedProducts = <String, String>{};
    for (var product in [...JetBrainsProduct.values]
      ..sort(Enum.compareByName)) {
      allowedProducts[product.name] = product.name.toJbName();
    }

    argParser.addOption('filter', help: 'Filter projects');
  }

  @override
  FutureOr<int>? run() async {
    String filter = argResults!['filter'] ?? '';
    filter = filter.toLowerCase();
    final response = AlfredResponse();
    logger.i("Search projects for all products with filter '$filter'");

    List<ResultItem> items = <ResultItem>[];

    for (var product in JetBrainsProduct.values) {
      try {
        items.addAll(itemsPerProduct(product));
      } catch (e) {
        // die silently
      }
    }

    if (filter.isNotEmpty) {
      items =
          items.toSet().where((ResultItem item) {
            if (item.title.toLowerCase().contains(filter) ||
                (item.variables != null &&
                    item.variables!.jbSearchBasename.toLowerCase().contains(
                      filter,
                    ))) {
              return true;
            }
            return false;
          }).toList();
    }

    response.renderItems(items.toList());

    return ExitCode.success.code;
  }

  List<ResultItem> itemsPerProduct(JetBrainsProduct product) {
    Iterable<ResultItem> items = <ResultItem>[];
    final jbProduct = JetBrainsProductLocator(product);
    final jbProjects = JetBrainsProjects(product);

    final Iterable<String> projects = jbProjects.retrieveRecentProjects();

    items = projects.map((projectPath) {
      final JetBrainsProjectName project = JetBrainsProjectName(projectPath);

      return ResultItemBuilder(
        name: project.name,
        path: projectPath,
        iconPath: jbProduct.locateApplication().absolute.path,
        binPath: jbProduct.locateBin().absolute.path,
      ).build();
    });

    // call to toList() will throw exception
    // (if some are thrown in previous map)
    return items.toList();
  }
}

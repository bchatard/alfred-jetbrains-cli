import 'dart:async';

import 'package:alfred_jetbrains_cli/alfred/alfred.dart';
import 'package:alfred_jetbrains_cli/exception/not_found.dart';
import 'package:alfred_jetbrains_cli/helper.dart';
import 'package:alfred_jetbrains_cli/jetbrains/jetbrains.dart';
import 'package:alfred_jetbrains_cli/logger.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';

class SearchCommand extends Command<int> {
  @override
  String get description => 'Search projects for a JetBrains product';

  @override
  String get name => 'search';

  SearchCommand() {
    final allowedProducts = <String, String>{};
    for (var product in [
      ...JetBrainsProduct.values,
    ]..sort(Enum.compareByName)) {
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
      ..addOption('filter', help: 'Filter projects');
  }

  @override
  FutureOr<int>? run() async {
    final JetBrainsProduct product = JetBrainsProduct.values.byName(
      argResults!['product'],
    );
    String filter = argResults!['filter'] ?? '';
    filter = filter.toLowerCase();
    final response = AlfredResponse();
    logger.i(
      "Search projects for ${product.name.toJbName()} with filter '$filter'",
    );

    Iterable<ResultItem> items = <ResultItem>[];

    try {
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

      if (filter.isNotEmpty) {
        items = items.where((ResultItem item) {
          if (item.title.toLowerCase().contains(filter) ||
              (item.variables != null &&
                  item.variables!.jbSearchBasename.toLowerCase().contains(
                    filter,
                  ))) {
            return true;
          }
          return false;
        });
      }
      // call to toList() will throw exception
      // (if some are thrown in previous map)
      items = items.toList();
    } on NotFoundException catch (e) {
      final notFound = ResultItemBuilder(
        name: e.message,
        path: e.troubleshoot ?? e.message,
        iconPath: iconError,
      ).build();
      items = [notFound];
    } catch (e) {
      final globalException = ResultItemBuilder(
        name: e.toString(),
        path: e.toString(),
        iconPath: iconBod,
      ).build();
      items = [globalException];
    }

    response.renderItems(items.toList());

    return ExitCode.success.code;
  }
}

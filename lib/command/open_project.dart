import 'dart:async';

import 'package:alfred_jetbrains_cli/alfred/alfred.dart';
import 'package:alfred_jetbrains_cli/exception/not_found.dart';
import 'package:alfred_jetbrains_cli/helper.dart';
import 'package:alfred_jetbrains_cli/jetbrains/jetbrains.dart';
import 'package:alfred_jetbrains_cli/logger.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';

class OpenProjectCommand extends Command<int> {
  @override
  String get description =>
      'Get project info based on path for a JetBrains product';

  @override
  String get name => 'open';

  OpenProjectCommand() {
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
      ..addOption('path', help: 'Path to a project', mandatory: true);
  }

  @override
  FutureOr<int>? run() async {
    final JetBrainsProduct product = JetBrainsProduct.values.byName(
      argResults!['product'],
    );
    final String projectPath = argResults!['path'];
    final response = AlfredResponse();
    logger.i("Open project in '$projectPath' for ${product.name.toJbName()}");

    ResultItem item;

    try {
      final jbProduct = JetBrainsProductLocator(product);

      final JetBrainsProjectName project = JetBrainsProjectName(projectPath);

      item = ResultItemBuilder(
        name: project.name,
        path: projectPath,
        iconPath: jbProduct.locateApplication().absolute.path,
        binPath: jbProduct.locateBin().absolute.path,
      ).build();
    } on NotFoundException catch (e) {
      item = ResultItemBuilder(
        name: e.message,
        path: e.troubleshoot ?? e.message,
        iconPath: iconError,
      ).build();
    } catch (e) {
      item = ResultItemBuilder(
        name: e.toString(),
        path: e.toString(),
        iconPath: iconBod,
      ).build();
    }

    response.renderItem(item);

    return ExitCode.success.code;
  }
}

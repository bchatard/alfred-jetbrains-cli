import 'dart:async';
import 'dart:convert';

import 'package:alfred_jetbrains_cli/jetbrains/product_config.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';

class ConfigurationCommand extends Command<int> {
  @override
  String get description =>
      'Generate configuration from default and your overrides';

  @override
  String get name => 'configuration';

  @override
  FutureOr<int>? run() async {
    print(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(JetBrainsProductConfiguration.config()),
    );

    return ExitCode.success.code;
  }
}

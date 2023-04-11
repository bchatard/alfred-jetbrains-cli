import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart' show ExitCode;
import 'package:logger/logger.dart';

import 'command/command.dart';
import 'generated/pubspec.dart';
import 'logger.dart';

class AlfredJetBrainsCli extends CommandRunner<int> {
  AlfredJetBrainsCli() : super(packageName, packageDescription) {
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Display the current version.',
      )
      ..addFlag(
        'verbose',
        help: 'Noisy logging, including all shell commands executed.',
      );
    addCommand(SearchCommand());
    addCommand(ConfigurationCommand());
  }

  @override
  void printUsage() => logger.i(usage);

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);
      if (topLevelResults['verbose'] == true || debugMode) {
        Logger.level = Level.debug;
      }
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      logger
        ..e(e.message)
        ..e('$stackTrace')
        ..i('')
        ..i(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      logger
        ..e(e.message)
        ..i('')
        ..i(e.usage);
      return ExitCode.usage.code;
    } finally {
      await loggerOutput.destroy();
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    // Fast track completion command
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }

    // Verbose logs
    logger
      ..d('Argument information:')
      ..d('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        logger.d('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final commandResult = topLevelResults.command!;
      logger
        ..d('  Command: ${commandResult.name}')
        ..d('    Command options:');
      for (final option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          logger.d('    - $option: ${commandResult[option]}');
        }
      }
    }

    // Run the command or show version
    final int? exitCode;
    if (topLevelResults['version'] == true) {
      logger.i(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }

    return exitCode;
  }
}

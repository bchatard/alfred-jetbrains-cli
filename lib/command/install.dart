import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alfred_jetbrains_cli/assets/assets.dart';
import 'package:alfred_jetbrains_cli/logger.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';

import '../helper.dart';

class InstallCommand extends Command<int> {
  @override
  String get description => 'Install the workflow';

  @override
  String get name => 'install';

  @override
  FutureOr<int> run() {
    consoleLogger.i('Install Workflow');
    // locate pref folder
    final pref = _locatePrefDirectory();
    // access workflows directory
    final workflows = Directory(join(pref.absolute.path, 'workflows'));
    // create folder if it doesn't exists (can happen on fresh install)
    workflows.createSync();
    // create workflow folder
    final workflow = Directory(join(workflows.absolute.path, workflowName));
    workflow.createSync();

    // Write files to workflow folder
    final infoPlistFile = File(join(workflow.absolute.path, 'info.plist'))
      ..writeAsStringSync(infoPlist, mode: FileMode.writeOnly);
    File(
      join(workflow.absolute.path, 'icon.png'),
    ).writeAsBytesSync(iconPng, mode: FileMode.writeOnly);
    consoleLogger.i('Workflow installed: ${infoPlistFile.absolute.path}');
    final String? binPath = _binPath();
    if (binPath != null) {
      consoleLogger.i('Move $binPath to workflow destination');

      final Directory workflowBin = Directory(
        join(workflow.absolute.path, 'bin'),
      )..createSync();
      File sourceFile = File(binPath);
      // Move the bin to the destination
      sourceFile.renameSync(
        '${workflowBin.absolute.path}/${basename(sourceFile.absolute.path)}',
      );
    }
    consoleLogger.i('Installation completed!');
    return ExitCode.success.code;
  }

  Directory _locatePrefDirectory() {
    final prefsFile = File(
      parsePath('~/Library/Application Support/Alfred/prefs.json'),
    );
    final prefs = jsonDecode(prefsFile.readAsStringSync());
    return Directory(prefs['current']);
  }

  String? _binPath() {
    if (Platform.executable.endsWith('/bin/dart') ||
        Platform.executable.endsWith('\\bin\\dart.exe')) {
      return null;
    }

    return Platform.executable;
  }
}

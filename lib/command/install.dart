import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    // locate pref folder
    final pref = _locatePrefDirectory();
    // access workflows directory
    final workflows = Directory(join(pref.absolute.path, 'workflows'));
    // prepare symbolic link
    final destWorkflow = Link(join(workflows.absolute.path, workflowName));

    // "install" (link) workflow
    destWorkflow.existsSync()
        ? destWorkflow.updateSync(Directory.current.absolute.path)
        : destWorkflow.createSync(Directory.current.absolute.path);
    return ExitCode.success.code;
  }

  Directory _locatePrefDirectory() {
    final prefsFile =
        File(parsePath('~/Library/Application Support/Alfred/prefs.json'));
    final prefs = jsonDecode(prefsFile.readAsStringSync());
    return Directory(prefs['current']);
  }
}

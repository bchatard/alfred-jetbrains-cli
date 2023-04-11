import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';

import '../generated/pubspec.dart';

final loggerOutput = _FileOutput();
final bool debugMode = _debugMode();
final bool alfredMode = _alfredMode();

final Logger logger = Logger(
  filter: _AlfredFilter(),
  printer: PrettyPrinter(
    printTime: true,
    colors: false,
    printEmojis: false,
    noBoxingByDefault: true,
    methodCount: 0,
  ),
  output: MultiOutput([loggerOutput, if (!alfredMode) ConsoleOutput()]),
  level: Level.info,
);

class _FileOutput extends LogOutput {
  late final IOSink _sink;

  late final File file = _getOutputFile();

  File _getOutputFile() {
    final DateTime now = DateTime.now();
    final String date = now.toIso8601String().split('T').first;
    return File(join(
      Directory.systemTemp.absolute.path,
      '${packageName}_$date.log',
    ));
  }

  @override
  void init() {
    _sink = file.openWrite(
      mode: FileMode.writeOnlyAppend,
      encoding: utf8,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink.writeAll(event.lines, '\n');
    _sink.writeln();
  }

  @override
  Future<void> destroy() async {
    await _sink.flush();
    await _sink.close();
  }
}

class _AlfredFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (!debugMode) {
      return false;
    }
    return event.level.index >= level!.index;
  }
}

bool _debugMode() {
  final Map<String, String> env = Platform.environment;
  return env.containsKey('alfred_debug');
}

bool _alfredMode() {
  final Map<String, String> env = Platform.environment;
  return env.containsKey('alfred_version');
}

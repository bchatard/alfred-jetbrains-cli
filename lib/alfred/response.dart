import 'dart:convert';

import 'package:alfred_jetbrains_cli/alfred/result_item.dart';
import 'package:alfred_jetbrains_cli/helper.dart';
import 'package:alfred_jetbrains_cli/logger.dart';
import 'package:alfred_jetbrains_cli/version.dart';
import 'package:path/path.dart';

class AlfredResponse {
  late DateTime _start;

  AlfredResponse() {
    _start = DateTime.now();
  }

  void renderItems(List<ResultItem> items) {
    _addDebug(items);

    final Map<String, dynamic> response = {
      'cache': {
        'seconds': 60 * 60 * 24, // one day
        'loosereload': true,
      },
      'items': items,
    };

    final encoder = debugMode
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    print(encoder.convert(response));
  }

  void renderItem(ResultItem item) {
    final encoder = debugMode
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    print(encoder.convert(item));
  }

  void _addDebug(List<ResultItem> items) {
    if (debugMode) {
      final version = ResultItemBuilder(
        name: 'Debug: CLI version $packageVersion',
        path: packageVersion,
        iconPath: iconNote,
      ).build();

      items.add(version);

      final debug = ResultItemBuilder(
        name: 'Debug: Log ${basename(loggerOutput.file.absolute.path)}',
        path: loggerOutput.file.absolute.path,
        iconPath: iconDebug,
      ).build();

      items.add(debug);

      final stop = DateTime.now();
      final diff = stop.difference(_start);

      final timer = ResultItemBuilder(
        name: 'Debug: Took ${diff.inMilliseconds}ms',
        path:
            'Started at: ${_start.toIso8601String()} || Ended at: ${stop.toIso8601String()}',
        iconPath: iconClock,
      ).build();
      items.add(timer);
    }
  }
}

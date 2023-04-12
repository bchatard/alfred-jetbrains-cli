import 'dart:convert';

import 'package:path/path.dart';

import '../helper.dart';
import '../logger.dart';
import 'alfred.dart';

class AlfredResponse {
  late DateTime _start;

  AlfredResponse() {
    _start = DateTime.now();
  }

  void render(List<ResultItem> items) {
    _addDebug(items);

    final Map<String, dynamic> response = {
      'items': items,
    };

    final encoder = debugMode ? JsonEncoder.withIndent('  ') : JsonEncoder();
    print(encoder.convert(response));
  }

  void _addDebug(List<ResultItem> items) {
    if (debugMode) {
      final debug = ResultItemBuilder(
        name: 'Debug: Log ${basename(loggerOutput.file.absolute.path)}',
        path: loggerOutput.file.absolute.path,
        iconPath:
            '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ProblemReport.icns',
      ).build();

      items.add(debug);

      final stop = DateTime.now();
      final diff = stop.difference(_start);

      final timer = ResultItemBuilder(
        name: 'Debug: Took ${diff.inMilliseconds}ms',
        path:
            'Started at: ${_start.toIso8601String()} || Ended at: ${stop.toIso8601String()}',
        iconPath:
            '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Clock.icns',
      ).build();
      items.add(timer);
    }
  }
}

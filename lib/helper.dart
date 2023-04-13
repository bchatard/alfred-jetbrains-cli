import 'dart:io';

const workflowName = '@bchatard-alfred-jetbrains-next';

final bool debugMode = _debugMode();
final bool alfredMode = _alfredMode();

String parsePath(String path) {
  if (path.contains('~')) {
    return path.replaceAll('~', Platform.environment['HOME']!);
  }
  return path;
}

bool _debugMode() {
  final Map<String, String> env = Platform.environment;
  return env.containsKey('alfred_debug');
}

bool _alfredMode() {
  final Map<String, String> env = Platform.environment;
  return env.containsKey('alfred_version');
}

import 'dart:io';

const String packageName = 'alfred_jetbrains_cli';
const String packageDescription = 'Companion CLI for Alfred JetBrains workflow';

const String workflowName = '@bchatard-alfred-jetbrains-next';

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

const String _iconBasePath =
    '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources';
const String iconNote = '$_iconBasePath/AlertNoteIcon.icns';
const String iconError = '$_iconBasePath/AlertStopIcon.icns';
const String iconDebug = '$_iconBasePath/ProblemReport.icns';
const String iconClock = '$_iconBasePath/Clock.icns';
const String iconNuclear = '$_iconBasePath/BurningIcon.icns';
const String iconBod = '$_iconBasePath/public.generic-pc.icns';

import 'dart:io';

import 'package:alfred_jetbrains_cli/jetbrains/project_name.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('JetBrainsProjectName', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('jb_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('returns basename when no .idea directory', () {
      final projectPath = path.join(tempDir.path, 'my-project');
      Directory(projectPath).createSync();
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'my-project');
    });

    test('reads name from .idea/name file', () {
      final projectPath = path.join(tempDir.path, 'project-dir');
      final ideaDir = Directory(path.join(projectPath, '.idea'));
      ideaDir.createSync(recursive: true);
      File(path.join(ideaDir.path, 'name')).writeAsStringSync('CustomName');
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'CustomName');
    });

    test('reads name from .idea/.name file', () {
      final projectPath = path.join(tempDir.path, 'project-dir2');
      final ideaDir = Directory(path.join(projectPath, '.idea'));
      ideaDir.createSync(recursive: true);
      File(path.join(ideaDir.path, '.name')).writeAsStringSync('DotName');
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'DotName');
    });

    test('reads name from .iml file', () {
      final projectPath = path.join(tempDir.path, 'project-dir3');
      final ideaDir = Directory(path.join(projectPath, '.idea'));
      ideaDir.createSync(recursive: true);
      File(path.join(ideaDir.path, 'my-module.iml')).writeAsStringSync('');
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'my-module');
    });

    test('prefers name file over .name file', () {
      final projectPath = path.join(tempDir.path, 'project-dir4');
      final ideaDir = Directory(path.join(projectPath, '.idea'));
      ideaDir.createSync(recursive: true);
      File(path.join(ideaDir.path, 'name')).writeAsStringSync('NameFile');
      File(path.join(ideaDir.path, '.name')).writeAsStringSync('DotNameFile');
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'NameFile');
    });

    test('handles .sln extension', () {
      final projectPath = path.join(tempDir.path, 'MySolution.sln');
      final projectName = JetBrainsProjectName(projectPath);
      expect(projectName.name, 'MySolution');
    });
  });
}

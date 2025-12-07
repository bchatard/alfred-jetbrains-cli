import 'dart:io';

import 'package:alfred_jetbrains_cli/jetbrains/projects_extractor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('JetBrainsProjectsExtractor', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('jb_extractor_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('recentProjectsExtractor extracts from additionalInfo map', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <component name="RecentProjectsManager">
    <option name="additionalInfo">
      <map>
        <entry key="\$USER_HOME\$/projects/project1" />
        <entry key="\$USER_HOME\$/projects/project2" />
      </map>
    </option>
  </component>
</application>''';
      final file = File(path.join(tempDir.path, 'recentProjects.xml'));
      file.writeAsStringSync(xmlContent);
      final projects = JetBrainsProjectsExtractor.recentProjectsExtractor(file);
      final home = Platform.environment['HOME'];
      expect(projects.length, 2);
      expect(projects, contains('$home/projects/project1'));
      expect(projects, contains('$home/projects/project2'));
    });

    test('recentProjectsExtractor extracts from recentPaths list', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <component name="RecentProjectsManager">
    <option name="recentPaths">
      <list>
        <option value="\$USER_HOME\$/dev/app1" />
        <option value="\$USER_HOME\$/dev/app2" />
      </list>
    </option>
  </component>
</application>''';
      final file = File(path.join(tempDir.path, 'recentProjects2.xml'));
      file.writeAsStringSync(xmlContent);
      final projects = JetBrainsProjectsExtractor.recentProjectsExtractor(file);
      final home = Platform.environment['HOME'];
      expect(projects.length, 2);
      expect(projects, contains('$home/dev/app1'));
    });

    test('recentProjectsExtractor returns empty for no matches', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <component name="OtherComponent">
  </component>
</application>''';
      final file = File(path.join(tempDir.path, 'empty.xml'));
      file.writeAsStringSync(xmlContent);
      final projects = JetBrainsProjectsExtractor.recentProjectsExtractor(file);
      expect(projects, isEmpty);
    });

    test('recentProjectDirectoriesExtractor extracts paths', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <component name="RecentDirectoryProjectsManager">
    <option name="recentPaths">
      <list>
        <option value="\$USER_HOME\$/workspace/proj" />
      </list>
    </option>
  </component>
</application>''';
      final file = File(path.join(tempDir.path, 'recentDirs.xml'));
      file.writeAsStringSync(xmlContent);
      final projects =
          JetBrainsProjectsExtractor.recentProjectDirectoriesExtractor(file);
      final home = Platform.environment['HOME'];
      expect(projects.length, 1);
      expect(projects.first, '$home/workspace/proj');
    });

    test('recentSolutionsExtractor extracts from additionalInfo', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <component name="RiderRecentProjectsManager">
    <option name="additionalInfo">
      <map>
        <entry key="\$USER_HOME\$/solutions/MySolution.sln" />
      </map>
    </option>
  </component>
</application>''';
      final file = File(path.join(tempDir.path, 'recentSolutions.xml'));
      file.writeAsStringSync(xmlContent);
      final solutions = JetBrainsProjectsExtractor.recentSolutionsExtractor(
        file,
      );
      final home = Platform.environment['HOME'];
      expect(solutions.length, 1);
      expect(solutions.first, '$home/solutions/MySolution.sln');
    });

    test('trustedPathsExtractor extracts trusted paths', () {
      final xmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<application>
  <option name="TRUSTED_PROJECT_PATHS">
    <map>
      <entry key="\$USER_HOME\$/trusted/project1" />
      <entry key="\$USER_HOME\$/trusted/project2" />
    </map>
  </option>
</application>''';
      final file = File(path.join(tempDir.path, 'trustedPaths.xml'));
      file.writeAsStringSync(xmlContent);
      final paths = JetBrainsProjectsExtractor.trustedPathsExtractor(file);
      final home = Platform.environment['HOME'];
      expect(paths.length, 2);
      expect(paths, contains('$home/trusted/project1'));
    });
  });
}

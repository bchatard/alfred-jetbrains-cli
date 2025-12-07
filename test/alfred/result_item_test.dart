import 'package:alfred_jetbrains_cli/alfred/result_item.dart';
import 'package:test/test.dart';

void main() {
  group('ResultItemText', () {
    test('constructor and properties', () {
      final text = ResultItemText(copy: 'copy text', largeType: 'large text');
      expect(text.copy, 'copy text');
      expect(text.largeType, 'large text');
    });

    test('toJson serializes correctly', () {
      final text = ResultItemText(copy: 'copy', largeType: 'large');
      final json = text.toJson();
      expect(json['copy'], 'copy');
      expect(json['largetype'], 'large');
    });

    test('fromJson deserializes correctly', () {
      final json = {'copy': 'copy text', 'largetype': 'large text'};
      final text = ResultItemText.fromJson(json);
      expect(text.copy, 'copy text');
      expect(text.largeType, 'large text');
    });
  });

  group('ResultItemIcon', () {
    test('constructor with path only', () {
      final icon = ResultItemIcon(path: '/path/to/icon.png');
      expect(icon.path, '/path/to/icon.png');
      expect(icon.type, isNull);
    });

    test('constructor with path and type', () {
      final icon = ResultItemIcon(path: '/path/to/app', type: 'fileicon');
      expect(icon.path, '/path/to/app');
      expect(icon.type, 'fileicon');
    });

    test('toJson excludes null type', () {
      final icon = ResultItemIcon(path: '/path/to/icon.icns');
      final json = icon.toJson();
      expect(json['path'], '/path/to/icon.icns');
      expect(json.containsKey('type'), isFalse);
    });

    test('toJson includes type when present', () {
      final icon = ResultItemIcon(path: '/path/to/app', type: 'fileicon');
      final json = icon.toJson();
      expect(json['type'], 'fileicon');
    });

    test('fromJson deserializes correctly', () {
      final json = {'path': '/icon/path', 'type': 'fileicon'};
      final icon = ResultItemIcon.fromJson(json);
      expect(icon.path, '/icon/path');
      expect(icon.type, 'fileicon');
    });
  });

  group('ResultItemVariables', () {
    test('constructor and properties', () {
      final vars = ResultItemVariables(
        jbProjectName: 'MyProject',
        jbBin: '/usr/local/bin/phpstorm',
        jbSearchBasename: 'my-project',
        jbIsNewBin: true,
      );
      expect(vars.jbProjectName, 'MyProject');
      expect(vars.jbBin, '/usr/local/bin/phpstorm');
      expect(vars.jbSearchBasename, 'my-project');
      expect(vars.jbIsNewBin, isTrue);
    });

    test('toJson serializes with correct keys', () {
      final vars = ResultItemVariables(
        jbProjectName: 'Project',
        jbBin: '/bin/idea',
        jbSearchBasename: 'project',
        jbIsNewBin: false,
      );
      final json = vars.toJson();
      expect(json['jb_project_name'], 'Project');
      expect(json['jb_bin'], '/bin/idea');
      expect(json['jb_search_basename'], 'project');
      expect(json['jb_is_new_bin'], isFalse);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'jb_project_name': 'Test',
        'jb_bin': '/bin/test',
        'jb_search_basename': 'test',
        'jb_is_new_bin': true,
      };
      final vars = ResultItemVariables.fromJson(json);
      expect(vars.jbProjectName, 'Test');
      expect(vars.jbBin, '/bin/test');
      expect(vars.jbSearchBasename, 'test');
      expect(vars.jbIsNewBin, isTrue);
    });

    test('fromJson uses default value for jbIsNewBin when missing', () {
      final json = {
        'jb_project_name': 'Test',
        'jb_bin': '/bin/test',
        'jb_search_basename': 'test',
      };
      final vars = ResultItemVariables.fromJson(json);
      expect(vars.jbIsNewBin, isFalse);
    });
  });

  group('ResultItem', () {
    test('constructor and properties', () {
      final text = ResultItemText(copy: 'copy', largeType: 'large');
      final icon = ResultItemIcon(path: '/icon');
      final item = ResultItem(
        uid: 'uid1',
        title: 'Title',
        match: 'match string',
        subtitle: 'Subtitle',
        arg: '/path/arg',
        autocomplete: 'auto',
        text: text,
        icon: icon,
      );
      expect(item.uid, 'uid1');
      expect(item.title, 'Title');
      expect(item.match, 'match string');
      expect(item.subtitle, 'Subtitle');
      expect(item.arg, '/path/arg');
      expect(item.autocomplete, 'auto');
      expect(item.variables, isNull);
    });

    test('toJson excludes null variables', () {
      final text = ResultItemText(copy: 'c', largeType: 'l');
      final icon = ResultItemIcon(path: '/i');
      final item = ResultItem(
        uid: 'u',
        title: 't',
        match: 'm',
        subtitle: 's',
        arg: 'a',
        autocomplete: 'ac',
        text: text,
        icon: icon,
      );
      final json = item.toJson();
      expect(json.containsKey('variables'), isFalse);
    });

    test('toJson includes variables when present', () {
      final text = ResultItemText(copy: 'c', largeType: 'l');
      final icon = ResultItemIcon(path: '/i');
      final vars = ResultItemVariables(
        jbProjectName: 'p',
        jbBin: 'b',
        jbSearchBasename: 's',
        jbIsNewBin: false,
      );
      final item = ResultItem(
        uid: 'u',
        title: 't',
        match: 'm',
        subtitle: 's',
        arg: 'a',
        autocomplete: 'ac',
        text: text,
        icon: icon,
        variables: vars,
      );
      final json = item.toJson();
      expect(json.containsKey('variables'), isTrue);
    });

    test('toString returns json string', () {
      final text = ResultItemText(copy: 'c', largeType: 'l');
      final icon = ResultItemIcon(path: '/i');
      final item = ResultItem(
        uid: 'u',
        title: 't',
        match: 'm',
        subtitle: 's',
        arg: 'a',
        autocomplete: 'ac',
        text: text,
        icon: icon,
      );
      expect(item.toString(), contains('uid'));
      expect(item.toString(), contains('title'));
    });
  });

  group('ResultItemBuilder', () {
    test('builds ResultItem without binPath', () {
      final builder = ResultItemBuilder(
        name: 'ProjectName',
        path: '/path/to/project',
        iconPath: '/icon.icns',
      );
      final item = builder.build();
      expect(item.uid, 'ProjectName');
      expect(item.title, 'ProjectName');
      expect(item.subtitle, '/path/to/project');
      expect(item.arg, '/path/to/project');
      expect(item.autocomplete, 'ProjectName');
      expect(item.match, 'ProjectName project');
      expect(item.variables, isNull);
      expect(item.icon.type, isNull);
    });

    test('builds ResultItem with binPath', () {
      final builder = ResultItemBuilder(
        name: 'MyProject',
        path: '/path/to/my-project',
        iconPath: '/app/icon.png',
        binPath: '/usr/local/bin/phpstorm',
      );
      final item = builder.build();
      expect(item.variables, isNotNull);
      expect(item.variables!.jbProjectName, 'MyProject');
      expect(item.variables!.jbBin, '/usr/local/bin/phpstorm');
      expect(item.variables!.jbSearchBasename, 'my-project');
      expect(item.variables!.jbIsNewBin, isFalse);
    });

    test('builds ResultItem with MacOS binPath sets jbIsNewBin to true', () {
      final builder = ResultItemBuilder(
        name: 'Project',
        path: '/path/project',
        iconPath: '/icon',
        binPath: '/Applications/PhpStorm.app/Contents/MacOS/phpstorm',
      );
      final item = builder.build();
      expect(item.variables!.jbIsNewBin, isTrue);
    });

    test('icon type is fileicon for non-icns files', () {
      final builder = ResultItemBuilder(
        name: 'Project',
        path: '/path',
        iconPath: '/path/to/app.app',
      );
      final item = builder.build();
      expect(item.icon.type, 'fileicon');
    });

    test('icon type is null for icns files', () {
      final builder = ResultItemBuilder(
        name: 'Project',
        path: '/path',
        iconPath: '/path/to/icon.icns',
      );
      final item = builder.build();
      expect(item.icon.type, isNull);
    });
  });
}

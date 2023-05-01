import 'dart:io';

import 'package:path/path.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class JetBrainsProjectName {
  final String projectPath;

  JetBrainsProjectName(this.projectPath);

  String get name => _searchName();

  String _searchName() {
    final String ideaPath = join(projectPath, '.idea');

    if (Directory(ideaPath).existsSync()) {
      final String? name = _fromFileContent(File(join(ideaPath, 'name')));
      if (name != null) {
        return name;
      }
      final String? dotName = _fromFileContent(File(join(ideaPath, '.name')));
      if (dotName != null) {
        return dotName;
      }

      final Iterable<FileSystemEntity> imlFiles = Directory(ideaPath)
          .listSync()
          .where((file) => extension(file.path) == '.iml');
      if (imlFiles.isNotEmpty) {
        return basenameWithoutExtension(imlFiles.first.absolute.path);
      }

      String? workspaceName =
          _fromWorkspace(File(join(ideaPath, 'workspace.xml')));
      if (workspaceName != null) {
        return workspaceName;
      }
    }

    // @todo: check if it's necessary (should not)
    if (extension(projectPath) == '.sln') {
      return basenameWithoutExtension(projectPath);
    }

    return basenameWithoutExtension(projectPath);
  }

  String? _fromFileContent(File file) {
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return null;
  }

  String? _fromWorkspace(File xmlFile) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
    final List<String> xpathSelectors = [
      "(//component[@name='ProjectView']/panes/pane[@id='ProjectPane']/subPane/PATH/PATH_ELEMENT/option/@value)[1]",
      "(//component[@name='ProjectView']/panes/pane[@id='ProjectPane']/subPane/expand/path/item[contains(@type, ':ProjectViewProjectNode')]/@name)[1]",
      "((/project/component[@name='ChangeListManager']/ignored[contains(@path, '.iws')]/@path)[1])",
    ];

    for (var xpath in xpathSelectors) {
      try {
        final Iterable<XmlNode> names = xmlDocument.xpath(xpath);
        if (names.isNotEmpty) {
          return names.first.value.toString();
        }
      } catch (e) {
        // die silently
        // skip this xpath
      }
    }

    return null;
  }
}

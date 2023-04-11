import 'dart:io';

import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class JetBrainsProjectsExtractor {
  static Iterable<String> _replaceHome(Iterable<XmlNode> nodes) {
    final Map<String, String> env = Platform.environment;
    return nodes.map<String>(
        (node) => node.value!.replaceAll('\$USER_HOME\$', env['HOME']!));
  }

  static Iterable<String> recentProjectsExtractor(
    File xmlFile,
  ) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());
    final Iterable<XmlNode> keys = xmlDocument.xpath(
        "//component[@name='RecentProjectsManager']/option[@name='additionalInfo']/map/entry/@key");
    if (keys.isNotEmpty) {
      return _replaceHome(keys);
    }

    final Iterable<XmlNode> values = xmlDocument.xpath(
        "//component[@name='RecentProjectsManager']/option[@name='recentPaths']/list/option/@value");
    if (values.isNotEmpty) {
      return _replaceHome(values);
    }

    return [];
  }

  static Iterable<String> recentProjectDirectoriesExtractor(
    File xmlFile,
  ) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());

    final Iterable<XmlNode> values = xmlDocument.xpath(
        "//component[@name='RecentDirectoryProjectsManager']/option[@name='recentPaths']/list/option/@value");
    if (values.isNotEmpty) {
      return _replaceHome(values);
    }

    return [];
  }

  static Iterable<String> recentSolutionsExtractor(
    File xmlFile,
  ) {
    final xmlDocument = XmlDocument.parse(xmlFile.readAsStringSync());

    final Iterable<XmlNode> values = xmlDocument.xpath(
        "//component[@name='RiderRecentProjectsManager']/option[@name='recentPaths']/list/option/@value");
    if (values.isNotEmpty) {
      return _replaceHome(values);
    }

    return [];
  }
}

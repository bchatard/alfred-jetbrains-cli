import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'result_item.g.dart';

/// Alfred Doc about the output format: https://www.alfredapp.com/help/workflows/inputs/script-filter/json
class ResultItemBuilder {
  String name;
  String path;
  String iconPath;
  String? binPath;

  ResultItemBuilder({
    required this.name,
    required this.path,
    required this.iconPath,
    this.binPath,
  });

  ResultItem build() {
    final text = ResultItemText(copy: path, largeType: name);
    final basePath = basename(path);

    ResultItemVariables? variables;
    if (binPath != null) {
      variables = ResultItemVariables(
        jbProjectName: name,
        jbBin: binPath!,
        jbSearchBasename: basePath,
        jbIsNewBin: binPath!.contains('MacOS'),
      );
    }

    final icon = ResultItemIcon(
      path: iconPath,
      type: extension(iconPath) == '.icns' ? null : 'fileicon',
    );

    return ResultItem(
      uid: name,
      title: name,
      match: '$name $basePath',
      subtitle: path,
      arg: path,
      autocomplete: name,
      text: text,
      icon: icon,
      variables: variables,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ResultItem {
  String uid;
  String title;
  String match;
  String subtitle;
  String arg;
  String autocomplete;
  ResultItemText text;
  ResultItemIcon icon;
  @JsonKey(includeIfNull: false)
  ResultItemVariables? variables;

  ResultItem({
    required this.uid,
    required this.title,
    required this.match,
    required this.subtitle,
    required this.arg,
    required this.autocomplete,
    required this.text,
    required this.icon,
    this.variables,
  });

  factory ResultItem.fromJson(Map<String, dynamic> json) =>
      _$ResultItemFromJson(json);

  Map<String, dynamic> toJson() => _$ResultItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class ResultItemText {
  String copy;
  @JsonKey(name: 'largetype')
  String largeType;

  ResultItemText({required this.copy, required this.largeType});

  factory ResultItemText.fromJson(Map<String, dynamic> json) =>
      _$ResultItemTextFromJson(json);

  Map<String, dynamic> toJson() => _$ResultItemTextToJson(this);
}

@JsonSerializable()
class ResultItemIcon {
  String path;
  @JsonKey(includeIfNull: false)
  String? type;

  ResultItemIcon({required this.path, this.type});

  factory ResultItemIcon.fromJson(Map<String, dynamic> json) =>
      _$ResultItemIconFromJson(json);

  Map<String, dynamic> toJson() => _$ResultItemIconToJson(this);
}

@JsonSerializable()
class ResultItemVariables {
  @JsonKey(name: 'jb_project_name')
  String jbProjectName;
  @JsonKey(name: 'jb_bin')
  String jbBin;
  @JsonKey(name: 'jb_search_basename')
  String jbSearchBasename;
  @JsonKey(name: 'jb_is_new_bin', defaultValue: false)
  bool jbIsNewBin = false;

  ResultItemVariables({
    required this.jbProjectName,
    required this.jbBin,
    required this.jbSearchBasename,
    required this.jbIsNewBin,
  });

  factory ResultItemVariables.fromJson(Map<String, dynamic> json) =>
      _$ResultItemVariablesFromJson(json);

  Map<String, dynamic> toJson() => _$ResultItemVariablesToJson(this);
}

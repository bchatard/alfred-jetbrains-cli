// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultItem _$ResultItemFromJson(Map<String, dynamic> json) => ResultItem(
      uid: json['uid'] as String,
      title: json['title'] as String,
      match: json['match'] as String,
      subtitle: json['subtitle'] as String,
      arg: json['arg'] as String,
      autocomplete: json['autocomplete'] as String,
      text: ResultItemText.fromJson(json['text'] as Map<String, dynamic>),
      icon: ResultItemIcon.fromJson(json['icon'] as Map<String, dynamic>),
      variables: json['variables'] == null
          ? null
          : ResultItemVariables.fromJson(
              json['variables'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultItemToJson(ResultItem instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'title': instance.title,
    'match': instance.match,
    'subtitle': instance.subtitle,
    'arg': instance.arg,
    'autocomplete': instance.autocomplete,
    'text': instance.text.toJson(),
    'icon': instance.icon.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('variables', instance.variables?.toJson());
  return val;
}

ResultItemText _$ResultItemTextFromJson(Map<String, dynamic> json) =>
    ResultItemText(
      copy: json['copy'] as String,
      largeType: json['largetype'] as String,
    );

Map<String, dynamic> _$ResultItemTextToJson(ResultItemText instance) =>
    <String, dynamic>{
      'copy': instance.copy,
      'largetype': instance.largeType,
    };

ResultItemIcon _$ResultItemIconFromJson(Map<String, dynamic> json) =>
    ResultItemIcon(
      path: json['path'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ResultItemIconToJson(ResultItemIcon instance) {
  final val = <String, dynamic>{
    'path': instance.path,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  return val;
}

ResultItemVariables _$ResultItemVariablesFromJson(Map<String, dynamic> json) =>
    ResultItemVariables(
      jbProjectName: json['jb_project_name'] as String,
      jbBin: json['jb_bin'] as String,
      jbSearchBasename: json['jb_search_basename'] as String,
      jbIsNewBin: json['jb_is_new_bin'] as bool? ?? false,
    );

Map<String, dynamic> _$ResultItemVariablesToJson(
        ResultItemVariables instance) =>
    <String, dynamic>{
      'jb_project_name': instance.jbProjectName,
      'jb_bin': instance.jbBin,
      'jb_search_basename': instance.jbSearchBasename,
      'jb_is_new_bin': instance.jbIsNewBin,
    };

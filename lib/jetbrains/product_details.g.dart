// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JetBrainsProductsDetails _$JetBrainsProductsDetailsFromJson(
  Map<String, dynamic> json,
) => JetBrainsProductsDetails(
  config: (json['config'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      $enumDecode(_$JetBrainsProductEnumMap, k),
      JetBrainsProductDetails.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$JetBrainsProductsDetailsToJson(
  JetBrainsProductsDetails instance,
) => <String, dynamic>{
  'config': instance.config.map(
    (k, e) => MapEntry(_$JetBrainsProductEnumMap[k]!, e.toJson()),
  ),
};

const _$JetBrainsProductEnumMap = {
  JetBrainsProduct.androidStudio: 'androidStudio',
  JetBrainsProduct.appCode: 'appCode',
  JetBrainsProduct.aqua: 'aqua',
  JetBrainsProduct.cLion: 'cLion',
  JetBrainsProduct.cLionNova: 'cLionNova',
  JetBrainsProduct.dataGrip: 'dataGrip',
  JetBrainsProduct.dataSpell: 'dataSpell',
  JetBrainsProduct.fleet: 'fleet',
  JetBrainsProduct.goLand: 'goLand',
  JetBrainsProduct.intelliJIdeaCommunity: 'intelliJIdeaCommunity',
  JetBrainsProduct.intelliJIdeaUltimate: 'intelliJIdeaUltimate',
  JetBrainsProduct.phpStorm: 'phpStorm',
  JetBrainsProduct.pyCharmProfessional: 'pyCharmProfessional',
  JetBrainsProduct.pyCharmCommunity: 'pyCharmCommunity',
  JetBrainsProduct.rider: 'rider',
  JetBrainsProduct.rubyMine: 'rubyMine',
  JetBrainsProduct.rustRover: 'rustRover',
  JetBrainsProduct.webStorm: 'webStorm',
  JetBrainsProduct.writerside: 'writerside',
};

JetBrainsProductDetails _$JetBrainsProductDetailsFromJson(
  Map<String, dynamic> json,
) => JetBrainsProductDetails(
  applicationNames: (json['applicationNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  preferencePrefix: json['preferencePrefix'] as String,
  binaries: (json['binaries'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$JetBrainsProductDetailsToJson(
  JetBrainsProductDetails instance,
) => <String, dynamic>{
  'applicationNames': instance.applicationNames,
  'preferencePrefix': instance.preferencePrefix,
  'binaries': instance.binaries,
};

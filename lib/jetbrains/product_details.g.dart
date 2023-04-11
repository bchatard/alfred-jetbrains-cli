// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JetBrainsProductsDetails _$JetBrainsProductsDetailsFromJson(
        Map<String, dynamic> json) =>
    JetBrainsProductsDetails(
      config: (json['config'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$JetBrainsProductEnumMap, k),
            JetBrainsProductDetails.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$JetBrainsProductsDetailsToJson(
        JetBrainsProductsDetails instance) =>
    <String, dynamic>{
      'config': instance.config
          .map((k, e) => MapEntry(_$JetBrainsProductEnumMap[k]!, e.toJson())),
    };

const _$JetBrainsProductEnumMap = {
  JetBrainsProduct.androidStudio: 'androidStudio',
  JetBrainsProduct.appCode: 'appCode',
  JetBrainsProduct.cLion: 'cLion',
  JetBrainsProduct.dataGrip: 'dataGrip',
  JetBrainsProduct.fleet: 'fleet',
  JetBrainsProduct.goLand: 'goLand',
  JetBrainsProduct.intelliJIdeaCommunity: 'intelliJIdeaCommunity',
  JetBrainsProduct.intelliJIdeaUltimate: 'intelliJIdeaUltimate',
  JetBrainsProduct.phpStorm: 'phpStorm',
  JetBrainsProduct.pyCharmProfessional: 'pyCharmProfessional',
  JetBrainsProduct.pyCharmCommunity: 'pyCharmCommunity',
  JetBrainsProduct.rider: 'rider',
  JetBrainsProduct.rubyMine: 'rubyMine',
  JetBrainsProduct.webStorm: 'webStorm',
};

JetBrainsProductDetails _$JetBrainsProductDetailsFromJson(
        Map<String, dynamic> json) =>
    JetBrainsProductDetails(
      applicationName: json['applicationName'] as String,
      preferencePrefix: json['preferencePrefix'] as String,
      binaries:
          (json['binaries'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$JetBrainsProductDetailsToJson(
        JetBrainsProductDetails instance) =>
    <String, dynamic>{
      'applicationName': instance.applicationName,
      'preferencePrefix': instance.preferencePrefix,
      'binaries': instance.binaries,
    };

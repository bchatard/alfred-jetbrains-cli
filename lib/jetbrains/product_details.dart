import 'package:json_annotation/json_annotation.dart';

import 'jetbrains.dart';

part 'product_details.g.dart';

typedef JetBrainsProductsConfig
    = Map<JetBrainsProduct, JetBrainsProductDetails>;

@JsonSerializable(explicitToJson: true)
class JetBrainsProductsDetails {
  JetBrainsProductsConfig config;

  JetBrainsProductsDetails({required this.config});

  factory JetBrainsProductsDetails.fromJson(Map<String, dynamic> json) =>
      _$JetBrainsProductsDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$JetBrainsProductsDetailsToJson(this);
}

@JsonSerializable()
class JetBrainsProductDetails {
  String applicationName;
  String preferencePrefix;
  List<String> binaries;

  JetBrainsProductDetails({
    required this.applicationName,
    required this.preferencePrefix,
    required this.binaries,
  });

  factory JetBrainsProductDetails.fromJson(Map<String, dynamic> json) =>
      _$JetBrainsProductDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$JetBrainsProductDetailsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

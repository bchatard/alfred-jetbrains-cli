import 'package:embed_annotation/embed_annotation.dart';

part 'assets.g.dart';

@EmbedStr("info.plist")
const infoPlist = _$infoPlist;

@EmbedBinary("icon.png")
const iconPng = _$iconPng;

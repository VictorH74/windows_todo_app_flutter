// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionTheme _$CollectionThemeFromJson(Map<String, dynamic> json) =>
    CollectionTheme(
      collectionTitle: json['collectionTitle'] as String,
      themeColorIndex: json['themeColorIndex'] as int? ?? 0,
    );

Map<String, dynamic> _$CollectionThemeToJson(CollectionTheme instance) =>
    <String, dynamic>{
      'collectionTitle': instance.collectionTitle,
      'themeColorIndex': instance.themeColorIndex,
    };

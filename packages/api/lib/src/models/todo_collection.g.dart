// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoCollection _$TodoCollectionFromJson(Map<String, dynamic> json) =>
    TodoCollection(
      title: json['title'] as String,
      iconIndex: json['iconIndex'] as int?,
      id: json['id'] as String?,
      colorThemeIndex: json['colorThemeIndex'] as int?,
    );

Map<String, dynamic> _$TodoCollectionToJson(TodoCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'colorThemeIndex': instance.colorThemeIndex,
      'iconIndex': instance.iconIndex,
    };

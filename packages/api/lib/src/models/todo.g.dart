// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
      id: json['id'] as String?,
      colorThemeIndex: json['colorThemeIndex'] as int?,
      annotation: json['annotation'] as String?,
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList(),
      list: (json['list'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'annotation': instance.annotation,
      'steps': instance.steps,
      'isDone': instance.isDone,
      'list': instance.list,
      'createdAt': instance.createdAt.toIso8601String(),
      'colorThemeIndex': instance.colorThemeIndex,
    };

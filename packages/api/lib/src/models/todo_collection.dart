import 'package:api/src/models/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'todo_collection.g.dart';

/// {@template todo_collection_item}
/// A single 'todo collection' item
///
/// Contains a [title] and [colorThemeIndex]
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [TodoCollection]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [TodoCollection.fromJson]
/// respectively.
///
/// {@template}
@immutable
@JsonSerializable()
class TodoCollection extends Equatable {
  /// {@macro todo_item}
  TodoCollection({
    required this.title,
    this.iconIndex,
    String? id,
    int? colorThemeIndex,
  })  : id = id ?? const Uuid().v4(),
        colorThemeIndex = colorThemeIndex ?? 1;

  /// Create a new [TodoCollection] from json
  factory TodoCollection.fromJson(JsonMap json) {
    return _$TodoCollectionFromJson(json);
  }

  /// Convert a instance to a [JsonMap]
  JsonMap toJson() {
    return _$TodoCollectionToJson(this);
  }

  /// The unique identifier of the 'todo collection'
  ///
  /// this field cannot be null
  final String id;

  /// the title of the 'collection'
  final String title;

  /// The theme color's index of the 'todo'
  ///
  /// Defaults to index 1
  final int colorThemeIndex;

  /// The icon index of the 'todo collection'
  ///
  /// Defaults to null
  final int? iconIndex;

  /// Returns a copy of this `todo collection` with the given values updated.
  ///
  /// {@macro todo_item}
  TodoCollection copyWith({
    String? id,
    String? title,
    int? iconIndex,
    int? colorThemeIndex,
  }) =>
      TodoCollection(
        id: id ?? this.id,
        title: title ?? this.title,
        iconIndex: iconIndex ?? this.iconIndex,
        colorThemeIndex: colorThemeIndex ?? this.colorThemeIndex,
      );

  @override
  List<Object?> get props => [];
}

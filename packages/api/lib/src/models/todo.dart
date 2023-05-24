import 'package:api/src/models/json_map.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

/// {@template todo_item}
/// A single `todo` item.
///
/// Contains a [title], [annotation] and [id], in addition to a [isDone]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Todo]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [Todo.fromJson]
/// respectively.
/// {@template}
@immutable
@JsonSerializable()
class Todo extends Equatable {
  /// {@macro todo_item}
  Todo({
    required this.title,
    this.isDone = false,
    String? id,
    String? annotation,
    List<String>? steps,
    List<String>? list,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        annotation = annotation ?? '',
        steps = steps ?? List.empty(),
        list = list ?? List.empty(),
        createdAt = createdAt ?? DateTime.now();

  /// create new 'todo' from json
  factory Todo.fromJson(JsonMap json) => _$TodoFromJson(json);

  /// convert a instance to a [JsonMap]
  JsonMap toJson() => _$TodoToJson(this);

  /// The unique identifier of the 'todo'
  ///
  /// Cannot be empty
  final String id;

  /// the title of the 'todo'
  ///
  /// required
  final String title;

  /// The annotation of the 'todo'
  ///
  /// Defaults to an empty string
  final String annotation;

  /// The steps of the 'todo'
  ///
  /// Defaults to an empty list
  final List<String> steps;

  /// Whether the 'todo' is completed
  ///
  /// Defaults to false
  final bool isDone;

  /// The annotation of the 'todo'
  ///
  /// Defaults to an empty list
  final List<String> list;

  /// The date of the created 'todo'
  ///
  /// Defaults to now
  final DateTime createdAt;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro todo_item}
  Todo copyWith({
    String? id,
    String? title,
    String? annotation,
    List<String>? steps,
    List<String>? list,
    bool? isDone,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        annotation: annotation ?? this.annotation,
        steps: steps ?? this.steps,
        list: list ?? this.list,
        isDone: isDone ?? this.isDone,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        annotation,
        steps,
        list,
        isDone,
      ];
}

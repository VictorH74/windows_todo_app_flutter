import 'package:api/api.dart';

/// {@template api}
/// The interface and models for an API providing access to todos
/// {@template}
abstract class Api {
  /// {@macro api}
  const Api();

  /// Retrieve all 'todo'
  Stream<List<Todo>> getTodos();

  /// Create or update a 'todo'
  Future<void> saveTodo(Todo todo);

  /// Delete a 'todo'
  Future<void> deleteTodo(String id);

  /// Delete all 'todo'
  Future<void> clearCompleted();

  /// Update the isDone field from all 'todo' to true
  Future<void> completeAll();

}

/// Not found 'todo' exception
class TodoNotFoundException implements Exception {}

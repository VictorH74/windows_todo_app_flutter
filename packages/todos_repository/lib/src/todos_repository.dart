import 'package:api/api.dart';

/// {@template todos_repository}
/// A repository that handles todo related requests.
/// {@endtemplate}
class TodosRepository {
  /// {@macro todos_repository}
  const TodosRepository({required Api api}) : _api = api;

  final Api _api;

  /// Retrieve all 'todo'
  Stream<List<Todo>> getTodos() => _api.getTodos();

  /// Retrieve all 'todo collection'
  Stream<List<TodoCollection>> getCollections() => _api.getCollections();

  /// Create or update a 'todo'
  Future<void> saveTodo(Todo todo) => _api.saveTodo(todo);

  /// Create or update a 'todo collection'
  Future<void> saveCollection(TodoCollection collection) => _api.saveCollection(collection);

  /// Delete a 'todo'
  Future<void> deleteTodo(String id) => _api.deleteTodo(id);

  /// Delete a 'todo collection'
  Future<void> deleteCollection(String title) => _api.deleteCollection(title);

  /// Delete all 'todo'
  Future<void> clearCompleted() => _api.clearCompleted();

  /// Update the isDone field from all 'todo' to true
  Future<void> completeAll() => _api.completeAll();
}

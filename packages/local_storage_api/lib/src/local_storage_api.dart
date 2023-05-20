import 'dart:convert';

import 'package:api/api.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_api}
/// A flutter implementation of the Api that uses local storage.
/// {@endtemplate}
class LocalStorageApi extends Api {
  /// {@macro local_storage_api}
  LocalStorageApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  void _init() {
    final todosJson = _getValue();
    if (todosJson != null) {
      final todos = List<Map<dynamic, dynamic>>.from(
        json.decode(todosJson) as List,
      ).map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap))).toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  /// The key used to manage the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  ///  this library.
  @visibleForTesting
  static const String kTodosCollectionKey = '__todos_collection_key__';

  /// call getString from _plugin passing the defined key
  String? _getValue() => _plugin.getString(kTodosCollectionKey);

  /// call setValue from _plugin passing the defined key
  Future<void> _setValue(String value) => _plugin.setString(kTodosCollectionKey, value);

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> clearCompleted() async {
    final todos = [..._todoStreamController.value]..removeWhere((t) => t.isDone);

    _todoStreamController.add(todos);
    return _setValue(json.encode(todos));
  }

  @override
  Future<void> completeAll() async {
    final todos = [..._todoStreamController.value];

    final newTodos = [for (var todo in todos) todo.copyWith(isDone: true)];

    _todoStreamController.add(newTodos);
    return _setValue(json.encode(newTodos));
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);

    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(json.encode(todos));
    }
  }

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);

    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todoStreamController.add(todos);
    return _setValue(json.encode(todos));
  }
}

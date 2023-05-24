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

  final _collectionStreamController = BehaviorSubject<List<TodoCollection>>.seeded(const []);

  void _init() {
    final todosJson = _getValue(kTodosKey);
    final collectionsJson = _getValue(kTodoCollectionsKey);
    if (todosJson != null) {
      final todos = List<Map<dynamic, dynamic>>.from(
        json.decode(todosJson) as List,
      ).map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap))).toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }

    if (collectionsJson != null) {
      final collections = List<Map<dynamic, dynamic>>.from(
        json.decode(collectionsJson) as List,
      ).map((jsonMap) => TodoCollection.fromJson(Map<String, dynamic>.from(jsonMap))).toList();
      _collectionStreamController.add(collections);
    } else {
      _collectionStreamController.add(const []);
    }
  }

  /// The key used to manage the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  ///  this library.
  @visibleForTesting
  static const String kTodosKey = '__todos_key__';

  /// The key used to manage the 'todo collections' locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  ///  this library.
  @visibleForTesting
  static const String kTodoCollectionsKey = '__todo_collections_key__';

  /// call getString from _plugin passing the defined key
  String? _getValue(String key) => _plugin.getString(key);

  /// call setValue from _plugin passing the defined key
  Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Stream<List<TodoCollection>> getCollections() {
    return _collectionStreamController.asBroadcastStream();
  }

  @override
  Future<void> clearCompleted() async {
    final todos = [..._todoStreamController.value]..removeWhere((t) => t.isDone);

    _todoStreamController.add(todos);
    return _setValue(kTodosKey, json.encode(todos));
  }

  @override
  Future<void> completeAll() async {
    final todos = [..._todoStreamController.value];

    final newTodos = [for (var todo in todos) todo.copyWith(isDone: true)];

    _todoStreamController.add(newTodos);
    return _setValue(kTodosKey, json.encode(newTodos));
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
      return _setValue(kTodosKey, json.encode(todos));
    }
  }

  @override
  Future<void> deleteCollection(String title) async {
    debugPrint('Title -> $title');
    final collections = [..._collectionStreamController.value];

    final collectionIndex = collections.indexWhere((c) => c.title == title);

    if (collectionIndex >= 0) {
      collections.removeAt(collectionIndex);

      final todos = [..._todoStreamController.value];

      for (var i = 0; i < todos.length; i++) {
        if (todos[i].list.contains(title)) {
          if (todos[i].list.length == 1) {
            todos.removeAt(i);
          } else {
            todos[i].list.removeWhere((str) => str == title);
          }
        }
      }

      _todoStreamController.add(todos);
      await _setValue(kTodosKey, json.encode(todos));
    }

    _collectionStreamController.add(collections);
    return _setValue(kTodoCollectionsKey, json.encode(collections));
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
    return _setValue(kTodosKey, json.encode(todos));
  }

  @override
  Future<void> saveCollection(TodoCollection collection) async {
    final collections = [..._collectionStreamController.value];
    final collectionIndex = collections.indexWhere((t) => t.title == collection.title);

    if (collectionIndex >= 0) {
      collections[collectionIndex] = collection;
    } else {
      collections.add(collection);
    }

    _collectionStreamController.add(collections);

    return _setValue(kTodoCollectionsKey, json.encode(collections));
  }
}

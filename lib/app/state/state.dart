import 'package:api/api.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  List<TodoCollection> _collections = [];
  List<Todo> _todos = [];
  int _themeColorIndex = 0;
  bool _error = false;

  List<TodoCollection> get collections => _collections;

  set collections(List<TodoCollection> collections) {
    _collections = collections;
    notifyListeners();
  }

  List<Todo> get todos => _todos;

  set todos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  int get themeColorIndex => _themeColorIndex;

  set themeColorIndex(int index) {
    _themeColorIndex = index;
    notifyListeners();
  }

  bool get error => _error;

  set error(bool newValue) {
    _error = newValue;
    notifyListeners();
  }
}


import 'package:api/api.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  set todos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }
}

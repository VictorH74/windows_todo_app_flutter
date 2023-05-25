import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todo_app_vh/home/home.dart';
import 'package:todo_app_vh/l10n/l10n.dart';
import 'package:todos_repository/todos_repository.dart';

class App extends StatelessWidget {
  const App({required this.todosRepository, super.key});

  final TodosRepository todosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todosRepository,
      child: AppView(todosRepository),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView(this.todosRepository, {super.key});

  final TodosRepository todosRepository;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final appState = AppState();
  late StreamSubscription<List<Todo>> _streamSubscription;

  @override
  initState() {
    super.initState();
    _streamSubscription = widget.todosRepository.getTodos().listen((todos) {
      appState.todos = todos;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
            primary: const Color.fromRGBO(133, 145, 253, 1),
            background: const Color.fromRGBO(44, 44, 44, 1),
            secondaryContainer: Colors.indigo, // drawer selected
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}

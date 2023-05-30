import 'dart:async';
import 'dart:developer';

import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todos_repository/todos_repository.dart';

void bootstrap({required Api api}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final todosRepository = TodosRepository(api: api);

  runZonedGuarded(
    () async => runApp(App(todosRepository: todosRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

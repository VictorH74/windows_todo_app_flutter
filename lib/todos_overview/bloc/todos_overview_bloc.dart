import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';

part 'todos_overview_state.dart';

final List<Color> themeColors = [
  Colors.white,
  Colors.blueAccent,
  Colors.purpleAccent,
  Colors.pink,
  Colors.redAccent,
  Colors.greenAccent,
  Colors.cyanAccent,
  Colors.deepPurple.shade300,
  Colors.pinkAccent,
  Colors.deepOrangeAccent.shade100,
  Colors.lightGreenAccent,
  Colors.cyan.shade600,
  Colors.white38
];

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewChangedTodo>(_onChangedTodo);
    on<TodosOverviewDeletedTodo>(_onDeletedTodo);
    on<TodosOverviewDeletedCollection>(_onDeletedCollection);
    on<TodosOverviewRequestThemeColor>(_onRequestThemeColor);
    on<TodosOverviewChangedThemeColor>(_onChangedThemeColor);
  }

  final TodosRepository _todosRepository;

  Future<void> _onChangedTodo(
    TodosOverviewChangedTodo event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    try {
      if (event.todo.list.isNotEmpty) {
        await _todosRepository.saveTodo(event.todo);
      } else {
        await _todosRepository.deleteTodo(event.todo.id);
      }

      emit(
        state.copyWith(
          status: TodosOverviewStatus.success,
          changedTodoStatus: event.changedTodoStatus,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }

  Future<void> _onDeletedTodo(
    TodosOverviewDeletedTodo event,
    Emitter<TodosOverviewState> emit,
  ) async {
    await _todosRepository.deleteTodo(event.id);
  }

  Future<void> _onDeletedCollection(
    TodosOverviewDeletedCollection event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));
    try {
      await _todosRepository.deleteCollection(event.title);
      emit(
        state.copyWith(status: TodosOverviewStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }

  Future<void> _onRequestThemeColor(
    TodosOverviewRequestThemeColor event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    try {
      final collectionTheme = await _todosRepository.getCollectionTheme(event.collectionTitle);
      final color = themeColors[collectionTheme != null ? collectionTheme.themeColorIndex : 1];
      emit(
        state.copyWith(status: TodosOverviewStatus.success, themeColor: color),
      );
    } catch (e) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }

  Future<void> _onChangedThemeColor(
    TodosOverviewChangedThemeColor event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final collectionTheme = event.collectionTheme;
    final color = collectionTheme.themeColorIndex < themeColors.length
        ? themeColors[collectionTheme.themeColorIndex]
        : Colors.white;

    try {
      await _todosRepository.saveCollectionTheme(event.collectionTheme);
      emit(
        state.copyWith(themeColor: color),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TodosOverviewStatus.failure),
      );
    }
  }
}

import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';

part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequest>(_onSubscriptionRequest);
    on<TodosOverviewAddedTodo>(_onAddedTodo);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequest(
    TodosOverviewSubscriptionRequest event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    final List<Todo> mockTodos = [
      Todo(
        id: 'fsdfsfdfdsdf',
        title: 'Finish this project',
        isDone: false,
        list: const ['task'],
        colorThemeIndex: 1,
        createdAt: DateTime.now(),
      ),
    ];

    await emit.forEach(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        todos: mockTodos,
        status: TodosOverviewStatus.success,
      ),
      onError: (_, __) => state.copyWith(status: TodosOverviewStatus.failure),
    );
  }

  Future<void> _onAddedTodo(
    TodosOverviewAddedTodo event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    try {
      await _todosRepository.saveTodo(event.todo);
      emit(state.copyWith(status: TodosOverviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }

// Future
}

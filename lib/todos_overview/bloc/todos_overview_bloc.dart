import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';

part 'todos_overview_state.dart';

final mockTodos = <Todo>[
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
  Todo(
    id: 'fsdfsfdfdsdf',
    title: 'Finish this project',
    isDone: false,
    list: const ['tasks'],
    createdAt: DateTime.now(),
  ),
];

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequest>(_onSubscriptionRequest);
    on<TodosOverviewChangedTodo>(_onChangedTodo);
    on<TodosOverviewDeletedTodo>(_onDeletedTodo);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequest(
    TodosOverviewSubscriptionRequest event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: TodosOverviewStatus.loading));

    await emit.forEach(
      _todosRepository.getTodos(),
      onData: (todos) {
        for (final t in todos) {
          debugPrint('${t.title} -> ${t.list}');
        }
        return state.copyWith(
          todos: todos,
          status: TodosOverviewStatus.success,
        );
      },
      onError: (_, __) => state.copyWith(status: TodosOverviewStatus.failure),
    );
  }

  Future<void> _onChangedTodo(
    TodosOverviewChangedTodo event,
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

  Future<void> _onDeletedTodo(
    TodosOverviewDeletedTodo event,
    Emitter<TodosOverviewState> emit,
  ) async {
    await _todosRepository.deleteTodo(event.id);
  }
// Future
}

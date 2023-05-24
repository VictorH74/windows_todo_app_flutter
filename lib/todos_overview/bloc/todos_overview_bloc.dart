import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';

part 'todos_overview_state.dart';


class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewChangedTodo>(_onChangedTodo);
    on<TodosOverviewDeletedTodo>(_onDeletedTodo);
    on<TodosOverviewDeletedCollection>(_onDeletedCollection);
  }

  final TodosRepository _todosRepository;

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

  Future<void> _onDeletedCollection(
      TodosOverviewDeletedCollection event,
      Emitter<TodosOverviewState> emit,
      ) async {
    try {
      await _todosRepository.deleteCollection(event.title);
      emit(state.copyWith(status: TodosOverviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TodosOverviewStatus.failure));
    }
  }
}

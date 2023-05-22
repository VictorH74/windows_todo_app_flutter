part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.todos = const [],
    this.status = TodosOverviewStatus.initial,
  });

  final List<Todo> todos;
  final TodosOverviewStatus status;

  TodosOverviewState copyWith({List<Todo>? todos, TodosOverviewStatus? status}) {
    return TodosOverviewState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        todos,
        status,
      ];
}

part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodosOverviewSubscriptionRequest extends TodosOverviewEvent {}

class TodosOverviewAddedTodo extends TodosOverviewEvent {
  TodosOverviewAddedTodo({required this.todo});

  final Todo todo;
}

class TodosOverviewDeletedTodo extends TodosOverviewEvent {
  TodosOverviewDeletedTodo({required this.id});

  final String id;
}

class TodosOverviewChangedTodo extends TodosOverviewEvent {
  TodosOverviewChangedTodo({required this.todo});

  final Todo todo;
}

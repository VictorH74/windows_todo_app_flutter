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
  TodosOverviewChangedTodo({
    required this.todo,
    required this.changedTodoStatus,
  });

  final Todo todo;
  final TodosOverviewChangedStatus changedTodoStatus;

  @override
  List<Object?> get props => [todo, changedTodoStatus];
}

class TodosOverviewDeletedCollection extends TodosOverviewEvent {
  TodosOverviewDeletedCollection({
    required this.title,
  });

  final String title;

  @override
  List<Object?> get props => [title];
}

class TodosOverviewRequestThemeColor extends TodosOverviewEvent {
  TodosOverviewRequestThemeColor({required this.collectionTitle});

  final String collectionTitle;

  @override
  List<Object?> get props => [collectionTitle];
}

class TodosOverviewChangedThemeColor extends TodosOverviewEvent {
  TodosOverviewChangedThemeColor({required this.collectionTheme});

  final CollectionTheme collectionTheme;

  @override
  List<Object?> get props => [collectionTheme];
}

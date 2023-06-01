part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

enum TodosOverviewChangedStatus {
  none,
  important,
  myDay,
  removedFromMyDay,
  removedFromImportant,
  completed,
  notCompleted,
}

class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.changedTodoStatus = TodosOverviewChangedStatus.none,
    this.themeColor = Colors.white,
  });

  final TodosOverviewStatus status;
  final TodosOverviewChangedStatus changedTodoStatus;
  final Color themeColor;

  TodosOverviewState copyWith({
    TodosOverviewStatus? status,
    TodosOverviewChangedStatus? changedTodoStatus,
    Color? themeColor,
  }) {
    return TodosOverviewState(
      status: status ?? this.status,
      themeColor: themeColor ?? this.themeColor,
      changedTodoStatus: changedTodoStatus ?? this.changedTodoStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        changedTodoStatus,
        themeColor,
      ];
}

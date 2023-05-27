part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.themeColor = Colors.white,
  });

  final TodosOverviewStatus status;
  final Color themeColor;

  TodosOverviewState copyWith({
    TodosOverviewStatus? status,
    Color? themeColor,
  }) {
    return TodosOverviewState(
      status: status ?? this.status,
      themeColor: themeColor ?? this.themeColor,
    );
  }

  @override
  List<Object?> get props => [
        status,
        themeColor,
      ];
}

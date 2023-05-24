part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
  });

  final TodosOverviewStatus status;

  TodosOverviewState copyWith({TodosOverviewStatus? status}) {
    return TodosOverviewState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}

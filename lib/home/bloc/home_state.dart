part of 'home_bloc.dart';

enum HomeStateStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStateStatus.loading,
    this.collections = const [],
    this.todos = const [],
  });

  final HomeStateStatus status;
  final List<TodoCollection> collections;
  final List<Todo> todos;

  HomeState copyWith({
    HomeStateStatus? status,
    List<TodoCollection>? collections,
    List<Todo>? todos,
  }) {
    if (todos != null) {
      for (final t in todos) {
        debugPrint('copyWith -> $t');
      }
    }
    return HomeState(
      status: status ?? this.status,
      collections: collections ?? this.collections,
      todos: todos ?? this.todos,
    );
  }

  @override
  List<Object?> get props => [status, collections, todos];
}

part of 'home_bloc.dart';

enum HomeStateStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStateStatus.loading,
    this.collections = const [],
  });

  final HomeStateStatus status;

  final List<TodoCollection> collections;

  HomeState copyWith({
    HomeStateStatus? status,
    List<TodoCollection>? collections,
  }) {
    return HomeState(
      status: status ?? this.status,
      collections: collections ?? this.collections,
    );
  }

  @override
  List<Object?> get props => [status, collections];
}

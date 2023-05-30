part of 'home_bloc.dart';

enum HomeStateStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStateStatus.initial,
  });

  final HomeStateStatus status;

  HomeState copyWith({
    HomeStateStatus? status,
    List<TodoCollection>? collections,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}

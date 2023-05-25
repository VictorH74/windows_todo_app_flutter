part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeCollectionsSubscriptionRequest extends HomeEvent {}

class HomeChangedCollection extends HomeEvent {
  HomeChangedCollection({required this.collection});

  final TodoCollection collection;

  @override
  List<Object?> get props => [collection];
}

import 'dart:io';

import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todos_repository/todos_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const HomeState()) {
    on<HomeCollectionsSubscriptionRequest>(_onCollectionsSubscriptionRequest);
    on<HomeTodosSubscriptionRequest>(_onTodosSubscriptionRequest);
    on<HomeChangedCollection>(_onChangedCollection);
  }

  final TodosRepository _todosRepository;

  Future<void> _onCollectionsSubscriptionRequest(
    HomeCollectionsSubscriptionRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    await emit.forEach(
      _todosRepository.getCollections(),
      onData: (collections) {
        return state.copyWith(
          collections: collections,
        );
      },
      onError: (_, __) => state.copyWith(status: HomeStateStatus.failure),
    );
  }

  Future<void> _onTodosSubscriptionRequest(
    HomeTodosSubscriptionRequest event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach(
      _todosRepository.getTodos(),
      onData: (todos) {
        return state.copyWith(
          todos: todos,
          status: HomeStateStatus.success,
        );
      },
      onError: (_, __) => state.copyWith(status: HomeStateStatus.failure),
    );
  }

  Future<void> _onChangedCollection(
    HomeChangedCollection event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      await _todosRepository.saveCollection(event.collection);
      emit(state.copyWith(status: HomeStateStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStateStatus.failure));
    }
  }
}

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
    on<HomeSubscriptionRequest>(_onSubscriptionRequest);
    on<HomeChangedCollection>(_onChangedCollection);
    on<HomeDeletedCollection>(_onDeletedCollection);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequest(
    HomeSubscriptionRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    await emit.forEach(
      _todosRepository.getCollections(),
      onData: (collections) => state.copyWith(
        collections: collections,
        status: HomeStateStatus.success,
      ),
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

  Future<void> _onDeletedCollection(
    HomeDeletedCollection event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _todosRepository.deleteCollection(event.title);
      emit(state.copyWith(status: HomeStateStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStateStatus.failure));
    }
  }
}

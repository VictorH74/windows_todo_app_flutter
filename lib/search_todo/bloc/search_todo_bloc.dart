import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_todo_event.dart';

class SearchTodoBloc extends Bloc<SearchTodoEvent, String> {
  SearchTodoBloc() : super('') {
    on<SearchTodoChangedStringEvent>(_onChangedString);
  }

  void _onChangedString(
    SearchTodoChangedStringEvent event,
    Emitter<String> emit,
  ) {
    emit(event.searchString);
  }
}

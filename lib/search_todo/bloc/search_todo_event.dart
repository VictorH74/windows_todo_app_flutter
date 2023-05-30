part of 'search_todo_bloc.dart';

abstract class SearchTodoEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SearchTodoChangedStringEvent extends SearchTodoEvent {

  SearchTodoChangedStringEvent({required this.searchString});
  final String searchString;
}

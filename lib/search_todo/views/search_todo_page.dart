import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todo_app_vh/search_todo/search_todo.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';
import 'package:todo_app_vh/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

class SearchTodoPage extends StatelessWidget {
  const SearchTodoPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const SearchTodoPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchTodoBloc()),
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          ),
        ),
      ],
      child: const SearchTodo(),
    );
  }
}

class SearchTodo extends StatelessWidget {
  const SearchTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchTodoBloc, String>(
      builder: (context, state) {
        final todos = context.watch<AppState>().todos;

        debugPrint(state);

        final filteredTodos = state == ''
            ? todos
            : todos.where(
                (t) => t.title.toLowerCase().contains(state.toLowerCase()),
              );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: TextField(
              onChanged: (value) {
                context.read<SearchTodoBloc>().add(
                      SearchTodoChangedStringEvent(searchString: value),
                    );
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          body: TodoTileListView(todos: filteredTodos.toList(),),
        );
      },
    );
  }
}

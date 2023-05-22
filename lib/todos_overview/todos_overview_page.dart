import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todo_app_vh/todos_overview/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(TodosOverviewSubscriptionRequest()),
      child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text('Empty list'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(15),
            children: [
              for (var todo in state.todos) TodoListTile(todo: todo),
            ],
          );
          // return ListView.builder(itemBuilder: (_) => )
        },
      ),
    );
  }
}

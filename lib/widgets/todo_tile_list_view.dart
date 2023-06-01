import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';

class TodoTileListView extends StatelessWidget {
  const TodoTileListView({
    required this.todos,
    this.collectionTitle,
    this.themeColor = Colors.white,
    super.key,
  });

  final String? collectionTitle;
  final List<Todo> todos;
  final Color themeColor;

  void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodosOverviewBloc, TodosOverviewState>(
      listenWhen: (prevState, newState) {
        return prevState.status == TodosOverviewStatus.loading &&
            newState.status == TodosOverviewStatus.success;
      },
      listener: (context, state) {
        final status = state.changedTodoStatus;
        if (status == TodosOverviewChangedStatus.myDay) {
          showSnackBar(
            context: context,
            message: 'Selected task added to My Day',
          );
        }
        if (status == TodosOverviewChangedStatus.important) {
          showSnackBar(
            context: context,
            message: 'Selected task added to Important',
          );
        }
        if (status == TodosOverviewChangedStatus.removedFromMyDay) {
          showSnackBar(
            context: context,
            message: 'Selected task removed from My Day',
          );
        }
        if (status == TodosOverviewChangedStatus.removedFromImportant) {
          showSnackBar(
            context: context,
            message: 'Selected task removed from Important',
          );
        }
        if (status == TodosOverviewChangedStatus.completed) {
          showSnackBar(context: context, message: 'Selected task completed');
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final t in todos.where((t) => !t.isDone))
              TodoListTile(
                color: themeColor,
                collectionTitle: collectionTitle,
                todo: t,
                key: Key(t.id),
              ),
            ExpansionTile(
              textColor: themeColor,
              iconColor: themeColor,
              initiallyExpanded: true,
              title: const Text('Completed'),
              children: [
                for (final t in todos.where((t) => t.isDone))
                  TodoListTile(
                    todo: t,
                    collectionTitle: collectionTitle,
                    color: themeColor,
                    key: UniqueKey(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

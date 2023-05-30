import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';

class TodoTileListView extends StatelessWidget {
  const TodoTileListView({
    required this.todos,
    this.themeColor = Colors.white,
    super.key,
  });

  final List<Todo> todos;
  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final t in todos.where((t) => !t.isDone))
            TodoListTile(
              color: themeColor,
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
                  color: themeColor,
                  key: UniqueKey(),
                ),
            ],
          )
        ],
      ),
    );
  }
}

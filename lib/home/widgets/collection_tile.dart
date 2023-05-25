import 'package:flutter/material.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile(this.leading, this.title, this.todosCount, {super.key});

  final Icon leading;
  final String title;
  final int todosCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, TodosOverview.route(context, title));
      },
      leading: leading,
      title: Text(title),
      trailing: Text(todosCount > 0 ? '$todosCount' : ''),
    );
  }
}

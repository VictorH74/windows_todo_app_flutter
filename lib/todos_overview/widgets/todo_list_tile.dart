import 'package:api/api.dart';
import 'package:flutter/material.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool isDone = false;
  bool isImportant = false;

  void addToImportantList() {
    setState(() {
      isImportant = !isImportant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      leading: Transform.scale(
        scale: 1.6,
        child: Checkbox(
          shape: const CircleBorder().copyWith(),
          value: isDone,
          onChanged: (value) {
            setState(() {
              isDone = value ?? false;
            });
          },
        ),
      ),
      title: Text(widget.todo.title),
      trailing: IconButton(
        iconSize: 35,
        icon: Icon(isImportant ? Icons.star : Icons.star_border_outlined),
        onPressed: addToImportantList,
      ),
    );
  }
}

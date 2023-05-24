import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';

const String important = "Important";

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    required this.todo,
    required Key key,
  }) : super(key: key);

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
  void initState() {
    isDone = widget.todo.isDone;
    isImportant = widget.todo.list.contains(important);
    super.initState();
  }

  void updateTodo(BuildContext context, Todo todo) {
    context.read<TodosOverviewBloc>().add(
          TodosOverviewChangedTodo(
            todo: todo,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.id),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewDeletedTodo(id: widget.todo.id),
              );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const CircleBorder(),
                value: isDone,
                onChanged: (value) {
                  final newValue = value ?? false;
                  updateTodo(context, widget.todo.copyWith(isDone: newValue));
                  setState(() {
                    isDone = newValue;
                  });
                },
              ),
            ),
            Expanded(child: Text(widget.todo.title)),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const StarBorder().copyWith(
                  innerRadiusRatio: 0.2,
                  valleyRounding: 0.5,
                  pointRounding: 0.5,
                ),
                value: isImportant,
                onChanged: (value) {
                  final newValue = value ?? false;
                  final list = [...widget.todo.list];

                  if (newValue) {
                    list.add(important);
                  } else {
                    list.removeWhere((e) => e == important);
                  }

                  updateTodo(
                    context,
                    widget.todo.copyWith(list: list),
                  );
                  setState(() {
                    isImportant = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
    // return BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
    //   builder: (context, state) {
    //     return Dismissible(
    //       key: Key(widget.todo.id),
    //       onDismissed: (DismissDirection direction) {
    //         if (direction == DismissDirection.endToStart) {
    //           context.read<TodosOverviewBloc>().add(
    //                 TodosOverviewDeletedTodo(id: widget.todo.id),
    //               );
    //         }
    //       },
    //       child: Container(
    //         margin: const EdgeInsets.only(bottom: 5),
    //         padding: const EdgeInsets.symmetric(vertical: 5),
    //         color: Theme.of(context).colorScheme.background,
    //         child: Row(
    //           children: [
    //             Transform.scale(
    //               scale: 1.2,
    //               child: Checkbox(
    //                 shape: const CircleBorder(),
    //                 value: isDone,
    //                 onChanged: (value) {
    //                   setState(() {
    //                     isDone = value ?? false;
    //                   });
    //                 },
    //               ),
    //             ),
    //             Expanded(child: Text(widget.todo.title)),
    //             Transform.scale(
    //               scale: 1.2,
    //               child: Checkbox(
    //                 shape: const StarBorder().copyWith(
    //                   innerRadiusRatio: 0.2,
    //                   valleyRounding: 0.5,
    //                   pointRounding: 0.5,
    //                 ),
    //                 value: isImportant,
    //                 onChanged: (value) {
    //                   setState(() {
    //                     isImportant = value ?? false;
    //                   });
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

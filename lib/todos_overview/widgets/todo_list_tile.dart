import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';

const String important = "Important";
const String myDay = "My Day";

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    required this.todo,
    required Key key,
    this.color = Colors.white,
  }) : super(key: key);

  final Todo todo;
  final Color color;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool isDone = false;
  bool isImportant = false;
  double paddingValue = 0;
  late bool toMyDay;

  void addToImportantList() {
    setState(() {
      isImportant = !isImportant;
    });
  }

  @override
  void initState() {
    isDone = widget.todo.isDone;
    isImportant = widget.todo.list.contains(important);
    toMyDay = widget.todo.list.contains(myDay);
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
      onUpdate: (details) {
        final unitNum = details.progress * 190;
        setState(() {
          paddingValue = unitNum;
        });
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewDeletedTodo(id: widget.todo.id),
              );
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        color: widget.collectionTitle != 'My Day' ? Colors.blue : Colors.grey,
        padding: EdgeInsets.only(left: paddingValue),
        child: Icon(toMyDay ? Icons.wb_sunny_outlined : Icons.wb_sunny_sharp),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: EdgeInsets.only(right: paddingValue),
        child: const Icon(Icons.delete),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            TodoTileCheckbox(
              shape: const CircleBorder(),
              checkMark: true,
              value: isDone,
              color: widget.color,
              onChanged: (value) {
                final newValue = value ?? false;
                updateTodo(context, widget.todo.copyWith(isDone: newValue));
                setState(() {
                  isDone = newValue;
                });
              },
            ),
            Expanded(
              child: Text(
                widget.todo.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TodoTileCheckbox(
              color: widget.color,
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
          ],
        ),
      ),
    );
  }
}

class TodoTileCheckbox extends StatelessWidget {
  const TodoTileCheckbox({
    required this.value,
    required this.onChanged,
    required this.shape,
    required this.color,
    this.checkMark = false,
    super.key,
  });

  final bool value;
  final void Function(bool? value) onChanged;
  final OutlinedBorder shape;
  final Color color;
  final bool checkMark;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: Checkbox(
        shape: shape,
        value: value,
        activeColor: color,
        checkColor: checkMark ? Theme.of(context).colorScheme.background : color,
        side: BorderSide(color: color),
        onChanged: onChanged,
      ),
    );
  }
}

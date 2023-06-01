import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todo_app_vh/todos_overview/widgets/widgets.dart';

Widget newTodoBottomSheet({
  required BuildContext context,
  required String collectionName,
}) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FormContainer(
        handleSubmit: (value) {
          context.read<TodosOverviewBloc>().add(
                TodosOverviewChangedTodo(
                  todo: Todo(
                    title: value,
                    list: [collectionName],
                  ),
                  changedTodoStatus: TodosOverviewChangedStatus.none,
                ),
              );
        },
      ),
    ),
  );
}

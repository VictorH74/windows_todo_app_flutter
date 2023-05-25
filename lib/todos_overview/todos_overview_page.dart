import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todo_app_vh/home/bloc/home_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todo_app_vh/todos_overview/widgets/widgets.dart';
import 'package:todo_app_vh/utils/constants.dart';
import 'package:todos_repository/todos_repository.dart';

enum MenuButtonItem { deleteCollection }

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({
    required this.collectionTitle,
    super.key,
  });

  final String collectionTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosOverviewBloc>(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      ),
      child: TodosOverview(
        collectionTitle,
      ),
    );
  }
}

class TodosOverview extends StatelessWidget {
  TodosOverview(this.collectionTitle) : super(key: UniqueKey());

  final String collectionTitle;

  static Route<void> route(
    BuildContext context,
    String collectionTitle,
  ) {
    return MaterialPageRoute(
      builder: (context) => TodosOverviewPage(collectionTitle: collectionTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabledPopupMenuItem = !kMainCollectionTitles.contains(collectionTitle);

    return BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) {
                  return bottomSheet(
                    context: context,
                    collectionName: collectionTitle,
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(title: Text(collectionTitle)),
                actions: [
                  PopupMenuButton(
                    onSelected: (MenuButtonItem item) {
                      switch (item) {
                        case MenuButtonItem.deleteCollection:
                          context.read<TodosOverviewBloc>().add(
                                TodosOverviewDeletedCollection(title: collectionTitle),
                              );
                          Navigator.pop(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuButtonItem>>[
                      PopupMenuItem<MenuButtonItem>(
                        enabled: enabledPopupMenuItem,
                        value: MenuButtonItem.deleteCollection,
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 13,
                            ),
                            Text('Delete collection'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Consumer<AppState>(
                  builder: (context, state, _) {
                    final todos = state.todos.reversed;

                    return Column(
                      children: [
                        for (var todo in todos.where((t) => t.list.contains(collectionTitle)))
                          TodoListTile(
                            todo: todo,
                            key: Key(todo.id),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget bottomSheet({
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
                ),
              );
        },
      ),
    ),
  );
}

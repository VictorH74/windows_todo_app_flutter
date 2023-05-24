import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/home/bloc/home_bloc.dart';
import 'package:todo_app_vh/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todo_app_vh/todos_overview/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

enum MenuButtonItem { deleteCollection }

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({
    required this.collectionTitle,
    required Key key,
  }) : super(key: key);

  final String collectionTitle;

  static Route<void> route(BuildContext context, String collectionTitle) {
    return MaterialPageRoute(
      builder: (context) => TodosOverviewPage(
        collectionTitle: collectionTitle,
        key: UniqueKey(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(
              TodosOverviewSubscriptionRequest(),
            ),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            todosRepository: context.read<TodosRepository>(),
          ),
        ),
      ],
      child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          final todos = state.todos.where(
            (t) => t.list.contains(collectionTitle),
          );
          final Widget displayBody;

          if (todos.isEmpty) {
            displayBody = const Center(
              child: Text('Empty list'),
            );
          } else {
            displayBody = Column(
              children: [
                for (var todo in todos)
                  TodoListTile(
                    todo: todo,
                    key: Key(todo.id),
                  ),
              ],
            );
          }
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (_) {
                    return bottomSheet(context: context, collectionName: collectionTitle);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  actions: [
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, _) {
                      return PopupMenuButton(
                        onSelected: (MenuButtonItem item) {
                          switch (item) {
                            case MenuButtonItem.deleteCollection:
                              context.read<HomeBloc>().add(
                                    HomeDeletedCollection(title: collectionTitle),
                                  );
                              Navigator.pop(context);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuButtonItem>>[
                          PopupMenuItem<MenuButtonItem>(
                            value: MenuButtonItem.deleteCollection,
                            child: Row(
                              children: const [
                                Icon(Icons.delete),
                                Text('Delete collection'),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                  pinned: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(collectionTitle),
                  ),
                ),
                SliverToBoxAdapter(
                  child: displayBody,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget bottomSheet({required BuildContext context, required String collectionName}) {
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

class FormContainer extends StatefulWidget {
  const FormContainer({
    required this.handleSubmit,
    super.key,
  });

  final void Function(String value) handleSubmit;

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fieldValue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).colorScheme.background,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: const CircleBorder(),
                value: false,
                onChanged: (bool? value) {},
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: fieldValue,
                onChanged: (String value) {
                  setState(() {
                    fieldValue = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                if (fieldValue.isEmpty) return;
                widget.handleSubmit(fieldValue);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.add_box,
                color: fieldValue.isEmpty ? Colors.white30 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todo_app_vh/home/home.dart';
import 'package:todo_app_vh/search_todo/search_todo.dart';
import 'package:todos_repository/todos_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Consumer<AppState>(
      builder: (context, state, _) {
        final todos = state.todos;
        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            backgroundColor: scheme.surface,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, SearchTodoPage.route());
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: Consumer<AppState>(
            builder: (context, state, _) {
              return Column(
                children: [
                  Column(
                    children: [
                      for (final data in mainCollectionsData)
                        CollectionTile(
                          data[0] as Icon,
                          data[1] as String,
                          todos
                              .where(
                                (t) => t.list.contains(data[1]),
                              )
                              .length,
                        ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var collection in state.collections)
                          CollectionTile(
                            const Icon(Icons.list),
                            collection.title,
                            todos
                                .where(
                                  (t) => t.list.contains(collection.title),
                                )
                                .length,
                          )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: BlocProvider(
            create: (_) => HomeBloc(
              todosRepository: context.read<TodosRepository>(),
            ),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      if (state.status == HomeStateStatus.loading) {
                        return;
                      }
                      _showNewCollectionFormDialog(context);
                    },
                    child: Row(children: const [
                      Icon(Icons.add, size: 30,),
                      SizedBox(width: 5,),
                      Text('New collection')
                    ],),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Add new collection
Future<void> _showNewCollectionFormDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (_) {
      return BlocProvider(
        create: (_) => HomeBloc(
          todosRepository: context.read<TodosRepository>(),
        ),
        child: AddCollectionForm(
          handleSubmit: (String value) {
            context.read<HomeBloc>().add(
                  HomeChangedCollection(
                    collection: TodoCollection(title: value),
                  ),
                );
          },
        ),
      );
    },
  );
}

List<List<dynamic>> mainCollectionsData = [
  [const Icon(Icons.wb_sunny_outlined, color: Colors.grey), 'My Day'],
  [Icon(Icons.star_border_outlined, color: Colors.red[300]), 'Important'],
  [Icon(Icons.text_snippet, color: Colors.teal[400]), 'Planned'],
  [const Icon(Icons.person_outline_rounded, color: Colors.greenAccent), 'Assigned to me'],
  [const Icon(Icons.home_filled, color: Colors.grey), 'Tasks'],
];

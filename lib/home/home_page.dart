import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/home/home.dart';
import 'package:todo_app_vh/theme/theme.dart';
import 'package:todos_repository/todos_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => HomeBloc(
            todosRepository: context.read<TodosRepository>(),
          )
            ..add(HomeTodosSubscriptionRequest())
            ..add(HomeCollectionsSubscriptionRequest()),
        )
      ],
      child: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Column(
                children: [
                  for (final data in mainCollectionsData)
                    CollectionTile(
                      data[0] as Icon,
                      data[1] as String,
                      state.todos.where(
                        (t) => t.list.contains(data[1]),
                      ).length,
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
                        state.todos.where(
                          (t) => t.list.contains(collection.title),
                        ).length,
                      )
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showNewCollectionFormDialog(context);
        },
      ),
    );
  }
}

// Add new collection
Future<void> _showNewCollectionFormDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (_) {
      return AddCollectionForm(
        handleSubmit: (String value) {
          context.read<HomeBloc>().add(
                HomeChangedCollection(
                  collection: TodoCollection(title: value),
                ),
              );
        },
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

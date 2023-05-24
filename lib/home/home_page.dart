import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/home/bloc/home_bloc.dart';
import 'package:todo_app_vh/home/widgets/add_collection_form.dart';
import 'package:todo_app_vh/theme/theme.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';
import 'package:todos_repository/todos_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => HomeBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(HomeSubscriptionRequest()),
        )
      ],
      child: const Home(),
    );
  }
}

class HomeListTile extends StatelessWidget {
  const HomeListTile(this.leading, this.title, {super.key});

  final Icon leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, TodosOverviewPage.route(context, title));
      },
      leading: leading,
      title: Text(title),
    );
  }
}

List<HomeListTile> mainListTiles = <HomeListTile>[
  const HomeListTile(
    Icon(Icons.wb_sunny_outlined, color: Colors.grey),
    'My Day',
  ),
  HomeListTile(
    Icon(Icons.star_border_outlined, color: Colors.red[300]),
    'Important',
  ),
  HomeListTile(
    Icon(Icons.text_snippet, color: Colors.teal[400]),
    'Planned',
  ),
  const HomeListTile(
    Icon(Icons.person_outline_rounded, color: Colors.greenAccent),
    'Assigned to me',
  ),
  const HomeListTile(
    Icon(Icons.home_filled, color: Colors.grey),
    'Tasks',
  ),
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showNewCollectionFormDialog(context);
        },
      ),
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          Column(
            children: mainListTiles,
          ),
          const Divider(thickness: 1),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStateStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: [
                    for (var collection in state.collections)
                      HomeListTile(const Icon(Icons.list), collection.title)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_vh/app/app.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';
import 'package:todo_app_vh/utils/constants.dart';
import 'package:todo_app_vh/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

enum MenuButtonItem { deleteCollection, changeTheme }

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({
    required this.collectionTitle,
    super.key,
  });

  final String collectionTitle;

  static Route<void> route({required String collectionTitle}) {
    return MaterialPageRoute(
      builder: (context) {
        return TodosOverviewPage(
          collectionTitle: collectionTitle,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosOverviewBloc>(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(TodosOverviewRequestThemeColor(collectionTitle: collectionTitle)),
      child: TodosOverview(collectionTitle),
    );
  }
}

class TodosOverview extends StatelessWidget {
  TodosOverview(
    this.collectionTitle,
  ) : super(key: UniqueKey());

  final String collectionTitle;

  static Route<void> route(
    String collectionTitle,
  ) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secAnimation) {
        return TodosOverviewPage(collectionTitle: collectionTitle);
      },
      transitionsBuilder: (context, animation, secAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.linear;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        final animationP = animation.drive(tween);
        return SlideTransition(
          position: animationP,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabledPopupMenuItem = !kMainCollectionTitles.contains(collectionTitle);

    return BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
      builder: (context, state) {
        final color = state.themeColor;
        final isVisibleFAB = state.status != TodosOverviewStatus.initial;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: color,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actionsIconTheme: IconThemeData(
                  color: color,
                ),
                pinned: true,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    collectionTitle,
                    style: TextStyle(color: color),
                  ),
                ),
                actions: [
                  PopupMenuButton(
                    onSelected: (MenuButtonItem item) {
                      switch (item) {
                        case MenuButtonItem.deleteCollection:
                          context.read<TodosOverviewBloc>().add(
                                TodosOverviewDeletedCollection(
                                  title: collectionTitle,
                                ),
                              );
                          Navigator.pop(context);
                          break;
                        case MenuButtonItem.changeTheme:
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (_) {
                              return changeThemeBottomSheet(
                                context: context,
                                onThemeSelect: (index) {
                                  context.read<TodosOverviewBloc>().add(
                                        TodosOverviewChangedThemeColor(
                                          collectionTheme: CollectionTheme(
                                            themeColorIndex: index,
                                            collectionTitle: collectionTitle,
                                          ),
                                        ),
                                      );
                                },
                              );
                            },
                          );
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
                      PopupMenuItem<MenuButtonItem>(
                        value: MenuButtonItem.changeTheme,
                        child: Row(
                          children: const [
                            Icon(Icons.palette),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Change theme'),
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
                    final todos = state.todos.reversed.where(
                      (t) => t.list.contains(collectionTitle),
                    );

                    return TodoTileListView(
                      collectionTitle: collectionTitle,
                      todos: todos.toList(),
                      themeColor: color,
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: isVisibleFAB ? 1 : 0,
            child: FloatingActionButton(
              backgroundColor: color,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return newTodoBottomSheet(
                      context: context,
                      collectionName: collectionTitle,
                    );
                  },
                );
              },
              child: Icon(
                Icons.add,
                size: 35,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        );
      },
    );
  }
}

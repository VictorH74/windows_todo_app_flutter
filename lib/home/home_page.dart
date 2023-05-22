import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_vh/theme/theme.dart';
import 'package:todo_app_vh/todos_overview/todos_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const Home(),
    );
  }
}

class Destination {
  const Destination(this.label, this.icon);

  final String label;
  final Widget icon;
}

List<Destination> destinations = <Destination>[
  const Destination('My Day', Icon(Icons.wb_sunny_outlined, color: Colors.grey)),
  Destination('Important', Icon(Icons.star_border_outlined, color: Colors.red[300])),
  Destination('Planned', Icon(Icons.text_snippet, color: Colors.teal[400])),
  const Destination(
      'Assigned to me', Icon(Icons.person_outline_rounded, color: Colors.greenAccent)),
  const Destination('Tasks', Icon(Icons.home_filled, color: Colors.grey)),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  late bool showNavigationDrawer;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    scaffoldKey.currentState!.closeDrawer();
  }

  void openDrawer() => scaffoldKey.currentState!.openDrawer();

  Widget buildDrawerScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          leading: IconButton(
        color: Theme.of(context).colorScheme.primary,
        iconSize: 30,
        onPressed: openDrawer,
        icon: const Icon(Icons.menu),
      )),
      backgroundColor: const Color.fromRGBO(32, 32, 32, 1),
      body: const SafeArea(
        bottom: false,
        top: false,
        child: TodosOverviewPage(),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Header',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...destinations.map(
            (Destination destination) {
              return NavigationDrawerDestination(
                label: Text(destination.label),
                icon: destination.icon,
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return buildDrawerScaffold(context);
  }
}

import 'package:flutter/material.dart';
import 'package:local_storage_api/local_storage_api.dart';
import 'package:todo_app_vh/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = LocalStorageApi(plugin: await SharedPreferences.getInstance());

  bootstrap(api: api);
}

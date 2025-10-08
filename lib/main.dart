import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import './view/todolists_view.dart';
import './data/database/app_database.dart';
import './service/navigator.dart';
import 'package:provider/provider.dart';
import './viewmodel/todolists_viewmodel.dart';

// Alleen importeren op desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    // Desktop: initialiseer sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await AppDatabase.instance.database;

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodolistsViewModel(NavigatorService.instance),
      child: MaterialApp(
        title: 'Todo App',
        home: const TodolistsView(),
        navigatorKey: NavigatorService.instance.navigatorKey,
      ),
    );
  }
}

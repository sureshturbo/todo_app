import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'todo_provider.dart';
import 'todo_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      ///its is used access the state
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        )
      ],
      child: MaterialApp(
        title: 'TODO App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TodoListScreen(),
      ),
    );
  }
}

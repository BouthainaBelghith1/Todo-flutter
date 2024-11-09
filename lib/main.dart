import 'package:flutter/material.dart';
import 'package:todo_app/core/themes/theme_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppThemes.appThemeData[AppTheme.lightTheme],
      darkTheme: AppThemes.appThemeData[AppTheme.darkTheme],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO APP'),
      ),
      body: const Center(
        child: Text('Hello World!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Bouton cliqué');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

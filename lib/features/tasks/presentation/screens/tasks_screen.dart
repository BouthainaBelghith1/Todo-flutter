import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/home/presentation/widgets/toolbar_action_theme_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO APP'),
        actions: const [
          ActionThemeButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>GoRouter.of(context).goNamed('register'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
 
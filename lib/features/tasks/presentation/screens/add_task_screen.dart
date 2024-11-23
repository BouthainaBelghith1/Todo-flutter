
import 'package:flutter/material.dart';
import 'package:todo_app/features/home/presentation/widgets/toolbar_action_theme_widget.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD TASK'),
        actions: const [
          ActionThemeButton(),
        ],
      ),
    );
  }
}
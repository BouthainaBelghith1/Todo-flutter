
import 'package:flutter/material.dart';
import 'package:todo_app/features/home/presentation/widgets/toolbar_action_theme_widget.dart';

class EditTaskScreen extends StatelessWidget {
  final String? id;
 
  const EditTaskScreen({super.key, this.id});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit TASK'),
        actions: const [
          ActionThemeButton(),
        ],
      ),
    );
  }
}
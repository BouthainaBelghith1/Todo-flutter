import 'package:flutter/material.dart';
import 'package:todo_app/features/home/presentation/widgets/toolbar_action_theme_widget.dart';

class DetailTaskScreen extends StatelessWidget {
  final String id;
 
  const DetailTaskScreen({super.key, required this.id});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK Detail'),
        actions: const [
          ActionThemeButton(),
        ],
      ),
    );
  }
}
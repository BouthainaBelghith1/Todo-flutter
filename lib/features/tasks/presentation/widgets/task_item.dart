import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskItem({required this.task, required this.onTap, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black45 : Colors.grey.shade300,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            task.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            task.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  key: ValueKey<bool>(task.isDone),
                  icon: Icon(
                    task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isDone ? Colors.green : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<TaskBloc>().add(UpdateTaskEvent(
                      task.copyWith(isDone: !task.isDone),
                    ));
                  },
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  key: ValueKey<bool>(task.isDone),
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 146, 138, 137),
                    size: 28,
                  ),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

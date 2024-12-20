import 'package:flutter/material.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

class TaskEditDialog extends StatefulWidget {
  final TaskEntity task;

  const TaskEditDialog({super.key, required this.task});

  @override
  _TaskEditDialogState createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.task.date), 
    ); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveTask() {
    // Convert the date string to DateTime if necessary
    // For example, if date is in 'yyyy-MM-dd' format
    DateTime? updatedDate = DateTime.tryParse(_dateController.text);

    final updatedTask = TaskEntity(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: updatedDate ?? DateTime.now(),  // Use the parsed date or the current date if invalid
      isDone: widget.task.isDone,
      isDeleted: widget.task.isDeleted,
      userId: widget.task.userId,
    );

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Due Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog without saving
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveTask,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

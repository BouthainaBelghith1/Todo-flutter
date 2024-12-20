import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String titleError = '';
  String descriptionError = '';
  String dateError = '';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Task'),
        actions: [
          IconButton(
            icon: BlocBuilder<SwitchThemeBloc, SwitchThemeState>(
              builder: (context, state) {
                return Icon(
                  state.themeValue ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
            onPressed: () {
              context.read<SwitchThemeBloc>().add(ToggleThemeEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: titleController,
              labelText: 'Task Title',
              keyboardType: TextInputType.text,
              errorText: titleError,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: descriptionController,
              labelText: 'Description',
              keyboardType: TextInputType.text,
              errorText: descriptionError,
            ),
            const SizedBox(height: 20),
            _buildDateField(context),
            const SizedBox(height: 30),
            _buildAddTaskButton(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, isDarkMode),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required String errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: errorText.isEmpty ? null : errorText,
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          dateController.text =
              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: dateController,
          decoration: InputDecoration(
            labelText: 'Task Date',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: dateError.isEmpty ? null : dateError,
          ),
          readOnly: true,
        ),
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ElevatedButton(
      onPressed: () {
        final title = titleController.text;
        final description = descriptionController.text;
        final date = DateTime.tryParse(dateController.text);

        setState(() {
          titleError = '';
          descriptionError = '';
          dateError = '';
        });

        bool isValid = true;

        if (title.isEmpty) {
          titleError = 'Title is required';
          isValid = false;
        }

        if (description.isEmpty) {
          descriptionError = 'Description is required';
          isValid = false;
        }

        if (date == null || date.isBefore(DateTime.now())) {
          dateError = 'Please select a valid date (today or later)';
          isValid = false;
        }

        if (isValid) {
          context.read<TaskBloc>().add(AddTaskEvent(
                id: Uuid().v4(),
                title: title,
                description: description,
                date: date ?? DateTime.now(),
              ));
          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        backgroundColor:
            isDarkMode ? Colors.deepPurple.shade900 : Colors.purpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Add Task',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, bool isDarkMode) {
  int _currentIndex = 2;

  return BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) {
      setState(() {
        _currentIndex = index; // Mettre à jour l'index
      });

      // Navigation vers les écrans correspondants
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasksScreen()),
        );
      } else if (index == 1) {
        // Naviguer vers le calendrier
      } else if (index == 2) {
        // Rester sur AddTaskScreen
      }
    },
    backgroundColor: isDarkMode ? Colors.black : Colors.white,
    selectedItemColor: isDarkMode ? Colors.deepPurple : Colors.purpleAccent,
    unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    elevation: 10,
    type: BottomNavigationBarType.fixed,
    items: [
      BottomNavigationBarItem(
        icon: _buildNavBarIcon(Icons.home, 0, _currentIndex, isDarkMode),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _buildNavBarIcon(Icons.calendar_today, 1, _currentIndex, isDarkMode),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: _buildNavBarIcon(Icons.add, 2, _currentIndex, isDarkMode),
        label: '',
      ),
    ],
  );
}

  Widget _buildNavBarIcon(
      IconData icon, int index, int currentIndex, bool isDarkMode) {
    final isSelected = index == currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDarkMode ? Colors.deepPurple.shade900 : Colors.purpleAccent)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 30,
        color: isSelected
            ? Colors.white
            : (isDarkMode ? Colors.white70 : Colors.black54),
      ),
    );
  }
}

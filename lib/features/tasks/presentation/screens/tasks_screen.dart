import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/task_item_screen.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_item.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _currentIndex = 0; // pour suivre l'index sélectionné du footer
  int totalTasks = 0;
  int doneTasks = 0;
  int undoneTasks = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksEvent(filter: TaskFilter.undone));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<TaskBloc>()
                  .add(GetTasksEvent(filter: TaskFilter.undone));
            },
          ),
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
            onPressed: () {
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TasksState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (totalTasks == 0) {
              totalTasks = state.tasks.where((task) => !task.isDeleted).length;
              doneTasks = doneTasks = state.tasks.where((task) => task.isDone).length;
              undoneTasks = state.tasks.where((task) => !task.isDone && !task.isDeleted).length;
            }

            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            }

            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.deepPurple.shade900
                          : Colors.purple.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.task, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Tasks',
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white)),
                                const SizedBox(height: 10),
                                Text('$totalTasks',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.done_all, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Done Tasks',
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white)),
                                const SizedBox(height: 10),
                                Text('$doneTasks',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.deepPurple.shade900
                          : Colors.purple.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cancel, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Undone Tasks',
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white)),
                                const SizedBox(height: 10),
                                Text('$undoneTasks',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(GetTasksEvent(filter: TaskFilter.undone));
                          },
                          child: const Text('Undone Tasks'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(GetTasksEvent(filter: TaskFilter.all));
                          },
                          child: const Text('All Tasks'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(GetTasksEvent(filter: TaskFilter.done));
                          },
                          child: const Text('Done Tasks'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<TaskBloc>()
                                .add(GetTasksEvent(filter: TaskFilter.deleted));
                          },
                          child: const Text('Deleted Tasks'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskItem(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskItemScreen(task: task),
                              ),
                            );
                          },
                          onDelete: () {
                            context.read<TaskBloc>().add(DeleteTaskEvent(task));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = 0;
          });
          if (index == 0) {
            // Naviguer vers l'écran d'accueil (Home)
          } else if (index == 1) {
            // Naviguer vers l'écran du calendrier
          } else if (index == 2) {
            // Naviguer vers l'écran d'ajout de tâche (AddTaskScreen)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          }
        },
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: isDarkMode ? Colors.purpleAccent : Colors.deepPurple,
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? (isDarkMode
                        ? Colors.deepPurple.shade900
                        : Colors.purpleAccent)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.home,
                size: 30,
                color: _currentIndex == 0
                    ? Colors.white
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _currentIndex == 1
                    ? (isDarkMode
                        ? Colors.deepPurple.shade900
                        : Colors.purpleAccent)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 30,
                color: _currentIndex == 1
                    ? Colors.white
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _currentIndex == 2
                    ? (isDarkMode
                        ? Colors.deepPurple.shade900
                        : Colors.purpleAccent)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                size: 30,
                color: _currentIndex == 2
                    ? Colors.white
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

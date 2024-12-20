import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/task_item_screen.dart';
import 'package:todo_app/features/tasks/presentation/widgets/bottom_navigation_bar.dart';
import 'package:todo_app/features/tasks/presentation/widgets/task_item.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _currentIndex = 0; 
  int totalTasks = 0;
  int doneTasks = 0;
  int undoneTasks = 0;
  int deletedTasks = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksEvent(filter: TaskFilter.undone));
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = 0;
    });

    if (index == 0) {
      GoRouter.of(context).goNamed('home');
    } else if (index == 1) {
      GoRouter.of(context).goNamed('calendar');
    } else if (index == 2) {
      GoRouter.of(context).goNamed('add-task');
    }
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
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TasksState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state is TaskLoaded) {
              totalTasks = state.tasks.where((task) => !task.isDeleted).length;
              doneTasks = state.tasks.where((task) => task.isDone).length;
              undoneTasks = state.tasks
                  .where((task) => !task.isDone && !task.isDeleted)
                  .length;
              deletedTasks = state.tasks.where((task) => task.isDeleted).length;
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
                        Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Deleted Tasks',
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white)),
                                const SizedBox(height: 10),
                                Text('$deletedTasks',
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

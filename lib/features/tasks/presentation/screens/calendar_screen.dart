import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/features/tasks/presentation/widgets/bottom_navigation_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<TaskEntity>> _tasks = {};
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    context.read<TaskBloc>().add(GetTasksEvent(filter: TaskFilter.undone));
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = 1;
    });

    if (index == 0) {
      GoRouter.of(context).goNamed('home');
    } else if (index == 1) {
      GoRouter.of(context).goNamed('Calendar');
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
        title: const Text('Calendar'),
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
            icon: Icon(Icons.logout),
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
            final tasksForSelectedDay = state.tasks.where((task) =>
                task.date.year == _selectedDay!.year &&
                task.date.month == _selectedDay!.month &&
                task.date.day == _selectedDay!.day &&
                !task.isDone);

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      // Reload tasks for the selected day
                      context
                          .read<TaskBloc>()
                          .add(GetTasksEvent(filter: TaskFilter.undone));
                    },
                    onFormatChanged: (format) {
                      // Handle format changes if needed
                    },
                    calendarStyle: CalendarStyle(
                      todayTextStyle: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.white),
                      selectedDecoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.deepPurple.shade900
                            : Colors.purple.shade200,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: theme.textTheme.labelLarge?.color,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.white),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  tasksForSelectedDay.isEmpty
                      ? Center(child: Text('No tasks for this day.'))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: tasksForSelectedDay.length,
                            itemBuilder: (context, index) {
                              final task = tasksForSelectedDay.elementAt(index);
                              return ListTile(
                                title: Text(task.title),
                                subtitle: Text(task.description),
                                trailing: Icon(
                                  Icons.check_circle,
                                  color: theme.iconTheme.color,
                                ),
                                onTap: () {
                                  // Navigate to task details or edit screen
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

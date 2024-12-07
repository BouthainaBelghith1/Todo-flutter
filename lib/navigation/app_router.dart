import 'package:go_router/go_router.dart';
import 'package:todo_app/core/pages/page_not_found_screen.dart';
import 'package:todo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:todo_app/features/auth/presentation/screens/register_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/detail_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/edit_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/tasks_screen.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/register',
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const TasksScreen();
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'add-task',//'/add-task
              name: 'add-task',
              builder: (context, state) => const AddTaskScreen(),
            ),
            GoRoute(
                path: 'detail-task/:id',
                name: 'detail-task',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return DetailTaskScreen(id: id!);
                }),
            GoRoute(
              path: 'edit-task/:id',
              name: 'edit-task',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return EditTaskScreen(id: id);
              },
            ),
          ]),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
}
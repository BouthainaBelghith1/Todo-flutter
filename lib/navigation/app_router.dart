import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/pages/page_not_found_screen.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/screens/login_screen.dart';
import 'package:todo_app/features/auth/presentation/screens/register_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/calendar_screen.dart';
import 'package:todo_app/features/tasks/presentation/screens/tasks_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const TasksScreen();
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'add-task',
              name: 'add-task',
              builder: (context, state) => const AddTaskScreen(),
            ),
            GoRoute(
              path: 'calendar',
              name: 'calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
          ]),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
    redirect: (context, state) {
      if (state.uri.toString() != '/register' &&
          state.uri.toString() != '/login') {
        final bool unauthenticated = authBloc.state is UnAuthenticatedState;
        final bool authenticated = authBloc.state is AuthenticatedState;
        if (unauthenticated) {
          return '/login';
        } else if (authenticated) {
          return '/';
        }
      }
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/themes/theme_manager.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/bloc/user_manager/user_manager_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/navigation/app_router.dart';

import 'injection_container.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await di.init();//wait init container (réservoir)
 
  runApp(const TodoApp());
}
 
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<SwitchThemeBloc>()),
        BlocProvider(create: (context) => di.sl<UserManagerBloc>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<TaskBloc>()),
      ],
      child: BlocBuilder<SwitchThemeBloc, SwitchThemeState>(
          builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: state.themeValue
              ? AppThemes.appThemeData[AppTheme.lightTheme]
              : AppThemes.appThemeData[AppTheme.darkTheme],
          routerConfig: di.sl<AppRouter>().router,
        );
      }),
    );
  }
}
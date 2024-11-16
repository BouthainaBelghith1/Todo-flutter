import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/themes/theme_manager.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/home/presentation/widgets/toolbar_action_theme_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchThemeBloc, SwitchThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.themeValue
              ? AppThemes.appThemeData[AppTheme.lightTheme]
              : AppThemes.appThemeData[AppTheme.darkTheme],
          home: Scaffold(
            appBar: AppBar(
              title: const Text('TODO APP'),
              actions: const [ActionThemeButton()],
            ),
            
          ),
        );
      },
    );
  }
}
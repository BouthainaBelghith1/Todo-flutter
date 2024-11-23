import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';

class ActionThemeButton extends StatelessWidget {
  const ActionThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchThemeBloc, SwitchThemeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              state.themeValue
                  ? BlocProvider.of<SwitchThemeBloc>(context)
                      .add(SwitchDarkThemeEvent())
                  : BlocProvider.of<SwitchThemeBloc>(context)
                      .add(SwitchLightThemeEvent());
            },
            child: state.themeValue
                ? const Icon(Icons.light_mode, size: 26.0)
                : const Icon(Icons.dark_mode, size: 26.0),
          ),
        );
      },
    );
  }
}
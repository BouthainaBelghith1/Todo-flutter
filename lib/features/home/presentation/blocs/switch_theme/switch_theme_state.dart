part of 'switch_theme_bloc.dart';

class SwitchThemeState extends Equatable {
  final bool themeValue;//true => Light , false => Dark
  const SwitchThemeState({required this.themeValue});
  
  @override
  List<Object> get props => [themeValue];
}

class SwitchThemeInitial extends SwitchThemeState {
  const SwitchThemeInitial({required super.themeValue});
}

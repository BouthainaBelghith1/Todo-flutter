part of 'switch_theme_bloc.dart';

abstract class SwitchThemeEvent extends Equatable {
  const SwitchThemeEvent();

  @override
  List<Object> get props => [];
}

class SwitchLightThemeEvent extends SwitchThemeEvent{

}

class SwitchDarkThemeEvent extends SwitchThemeEvent{
  
}

class ToggleThemeEvent extends SwitchThemeEvent {}

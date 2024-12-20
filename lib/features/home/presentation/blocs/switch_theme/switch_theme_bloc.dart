import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'switch_theme_event.dart';
part 'switch_theme_state.dart';

class SwitchThemeBloc extends Bloc<SwitchThemeEvent, SwitchThemeState> {
  SwitchThemeBloc() : super(const SwitchThemeInitial(themeValue: true)) {
    on<ToggleThemeEvent>((event, emit) {
      final newThemeValue = !state.themeValue;
      emit(SwitchThemeInitial(themeValue: newThemeValue));
    });
  }
  
}
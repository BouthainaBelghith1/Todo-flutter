import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'switch_theme_event.dart';
part 'switch_theme_state.dart';

class SwitchThemeBloc extends Bloc<SwitchThemeEvent, SwitchThemeState> {
  SwitchThemeBloc() : super(const SwitchThemeInitial(themeValue: true)) {
    on<SwitchThemeEvent>((event, emit) {
      if (event is SwitchLightThemeEvent){
        emit(const SwitchThemeInitial(themeValue: true));
      }else{
        emit(const SwitchThemeInitial(themeValue: false));
      }
    });
  }
  
}
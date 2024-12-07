import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/core/failures/auth_failures.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/strings/failures.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:todo_app/features/auth/domain/usecases/register_user.dart';

part 'user_manager_event.dart';
part 'user_manager_state.dart';

class UserManagerBloc extends Bloc<UserManagerEvent, UserManagerState> {
 
  final RegisterUserUseCase registerUserUseCase;
 
  UserManagerBloc({required this.registerUserUseCase})
      : super(UserManagerInitial()) {
    on<UserManagerEvent>((event, emit) async {
      if (event is RegisterEvent) {
        //Patienter ..en cours de traitement ---> spinner
        emit(RegisteringUserState());
        //callable
        //Either (left, right)
        final failureOrDoneRegister = await registerUserUseCase(event.user);
 
        failureOrDoneRegister.fold(
            (left) => emit(RegisterUserErrorState(
                message: _mapRegisterFailureToMessage(left))),
            (_) => emit(RegisteredUserState()));
      }
    });
  }
 
  String _mapRegisterFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case RegisterUserWeakPwdFailure:
        return REGISTER_USER_WEAK_PWD;
      case RegisterUserUsedEmailFailure:
        return REGISTER_USER_EMAIL_USED;
      default:
        return "Erreur inconnue...";
    }
  }
 
  /**TODO update user bloc */
}
 
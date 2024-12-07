import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/failures/auth_failures.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/firebase/firebase_service.dart';
import 'package:todo_app/core/strings/failures.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_user.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_out_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUserUseCase signInUserUseCase;
  final SignOutUserUseCase signOutUserUseCase;
 
  final FirebaseService firebaseService;
 
  AuthBloc(
      {required this.signInUserUseCase,
      required this.signOutUserUseCase,
      required this.firebaseService})
      : super(AuthInitial()) {
       
    firebaseService.getAuth().authStateChanges().listen((User? user) {
      if (user == null) {
        emit(UnAuthenticatedState());
      }
    });
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginProgressState());
 
        final failureOrDoneLogin = await signInUserUseCase(event.user);
 
        failureOrDoneLogin.fold((left) {
          emit(AuthErrorState(message: _mapLoginFailureToMessage(left)));
          emit(UnAuthenticatedState());
        }, (_) => emit(AuthenticatedState(message: "authenticated")));
      } else if (event is LogoutEvent) {
        emit(LogOutInProgressState());
 
        final failureOrDoneLogOut = await signOutUserUseCase();
 
        failureOrDoneLogOut.fold((left) {
          emit(AuthErrorState(message: _mapLogOutFailureToMessage(left)));
          emit(AuthenticatedState(message: "authenticated"));
        }, (_) => emit(UnAuthenticatedState()));
      }
    });
  }
 
  String _mapLoginFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case SignInWrongPwdFailure:
        return LOGIN_USER_WRONG_PWD;
      case SignInUserNotFoundFailure:
        return LOGIN_USER_NOT_FOUND;
      default:
        return "Erreur inconnue...";
    }
  }
 
  String _mapLogOutFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Erreur inconnue...";
    }
  }
}

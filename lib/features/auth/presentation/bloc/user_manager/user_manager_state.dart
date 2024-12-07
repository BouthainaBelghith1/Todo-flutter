part of 'user_manager_bloc.dart';

abstract class UserManagerState extends Equatable {
  const UserManagerState();
 
  @override
  List<Object> get props => [];
}
 
class UserManagerInitial extends UserManagerState {}
 
class RegisteringUserState extends UserManagerState {}//Register en cours
 
class RegisteredUserState extends UserManagerState {}// Register Done with success
 
class RegisterUserErrorState extends UserManagerState {// Register Error
  final String message;
  const RegisterUserErrorState({required this.message});
 
  @override
  List<Object> get props => [message];
}
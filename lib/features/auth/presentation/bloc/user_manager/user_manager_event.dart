part of 'user_manager_bloc.dart';

abstract class UserManagerEvent extends Equatable {
  const UserManagerEvent();
 
  @override
  List<Object> get props => [];
}
 
class RegisterEvent extends UserManagerEvent {
  //Porteuse d'info
  final UserEntity user;
 
  const RegisterEvent({required this.user});
 
  @override
  List<Object> get props => [user];
}

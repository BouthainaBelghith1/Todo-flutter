import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository{
 
  Future<Either<Failure,Unit>> registerUser(UserEntity user);
  Future<Either<Failure,Unit>> updateUser(UserEntity user);
 
  Future<Either<Failure,Unit>> signIn(UserEntity user);
  Future<Either<Failure,Unit>> signOut();
}
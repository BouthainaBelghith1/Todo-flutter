import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/auth/domain/repositories/user_repository.dart';
import 'package:todo_app/features/auth/domain/entities/user_entity.dart';

class UpdateUserUseCase {
  final UserRepository userRepository;
 
  UpdateUserUseCase(this.userRepository);
 
  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await userRepository.updateUser(user);
  }
}
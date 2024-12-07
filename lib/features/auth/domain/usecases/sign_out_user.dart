import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/auth/domain/repositories/user_repository.dart';

class SignOutUserUseCase {
  final UserRepository userRepository;
 
  SignOutUserUseCase(this.userRepository);
 
  Future<Either<Failure, Unit>> call() async {
    return await userRepository.signOut();
  }
}
import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class AddTaskUseCase{
  final TaskRepository taskRepository;
 
  AddTaskUseCase(this.taskRepository);
 
  Future<Either<Failure,Unit>> call(TaskEntity taskEntity) async{
    return await taskRepository.addTask(taskEntity);
  }
}
import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class GetAllTasksUseCase{
  final TaskRepository taskRepository;
 
  GetAllTasksUseCase(this.taskRepository);
 
  Future<Either<Failure, List<TaskEntity>>> call() async{
    return await taskRepository.getAllTasks();
  }
 
 
}
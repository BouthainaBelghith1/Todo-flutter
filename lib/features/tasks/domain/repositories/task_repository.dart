import 'package:dartz/dartz.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
 
  Future<Either<Failure,List<TaskEntity>>> getAllTasks();
  Future<Either<Failure,Unit>> addTask(TaskEntity taskEntity);
  Future<Either<Failure, Unit>> updateTask(TaskEntity taskEntity);
  Future<Either<Failure, Unit>> deleteTask(TaskEntity taskEntity);
}
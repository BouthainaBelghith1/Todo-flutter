import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/failures/failures.dart';
import 'package:todo_app/core/failures/tasks_failures.dart';
import 'package:todo_app/core/network/network_info.dart';
import 'package:todo_app/features/tasks/data/datasources/task_data_source.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource taskDataSource;
  final NetwortkInfo networtkInfo;
 
  TaskRepositoryImpl(
      {required this.taskDataSource, required this.networtkInfo});
 
  @override
  Future<Either<Failure, Unit>> addTask(TaskEntity taskEntity) async {
    TaskModel taskModel = TaskModel(
        id: taskEntity.id,
        title: taskEntity.title,
        description: taskEntity.description,
        date: taskEntity.date,
        isDone: taskEntity.isDone,
        isDeleted: taskEntity.isDeleted);
 
    if (await networtkInfo.isConnected) {
      try {
        var response = await taskDataSource.addTask(taskModel);
        return const Right(unit);
      } catch (e) {
        return Left(AddTaskFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
 
  @override
  Future<Either<Failure, Unit>> deleteTask(TaskEntity taskEntity) async {
    TaskModel taskModel = TaskModel(
        id: taskEntity.id,
        title: taskEntity.title,
        description: taskEntity.description,
        date: taskEntity.date,
        isDone: taskEntity.isDone,
        isDeleted: taskEntity.isDeleted);
    if (await networtkInfo.isConnected) {
      try{
        var response = taskDataSource.deleteTask(taskModel);
        return const Right(unit);
 
      }catch(e){
        return Left(DeleteTasksFailure());
      }
     
    } else {
      return Left(OfflineFailure());
    }
  }
 
  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    if (await networtkInfo.isConnected) {
      try {
        var response = await taskDataSource.getAllTasks();
        List<TaskModel> tasks = List.empty();
 
        response.docs.forEach((doc) {
          tasks.add(TaskModel.fromJson({
            'id': doc['id'],
            'title': doc['title'],
            'description': doc['description'],
            'date': DateFormat('d/m/y').format(doc['date'])
          }));
        });
 
        return Right(tasks);
      } catch (e) {
        return Left(GetTasksFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
 
  @override
  Future<Either<Failure, Unit>> updateTask(TaskEntity taskEntity) async {
    TaskModel taskModel = TaskModel(
        id: taskEntity.id,
        title: taskEntity.title,
        description: taskEntity.description,
        date: taskEntity.date,
        isDone: taskEntity.isDone,
        isDeleted: taskEntity.isDeleted);
 
    if (await networtkInfo.isConnected) {
      try {
        var response = await taskDataSource.updateTask(taskModel);
        return const Right(unit);
      } catch (e) {
        return Left(UpdateTaskFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
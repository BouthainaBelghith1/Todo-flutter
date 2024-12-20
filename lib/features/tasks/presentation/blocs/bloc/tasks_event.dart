part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TasksEvent {
  final TaskFilter filter;

  const GetTasksEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class AddTaskEvent extends TasksEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;
  final bool isDeleted;
  const AddTaskEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [id, title, description, date, isDone, isDeleted];
}

class UpdateTaskEvent extends TasksEvent {
  final TaskEntity task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TasksEvent {
  final TaskEntity task;

  const DeleteTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}



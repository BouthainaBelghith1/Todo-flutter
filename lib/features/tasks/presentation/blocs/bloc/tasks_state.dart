part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {
  @override
  List<Object?> get props => [];
}

class TaskLoading extends TasksState {
  @override
  List<Object?> get props => []; 
}

class TaskError extends TasksState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message]; 
}

class TaskLoaded extends TasksState {
  final List<TaskEntity> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object?> get props => [tasks]; 
}

class TaskAddedState extends TasksState {
  final TaskEntity task;

  const TaskAddedState(this.task);

  @override
  List<Object> get props => [task]; 
}

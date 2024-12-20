import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:todo_app/features/tasks/domain/usecases/add_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:todo_app/features/tasks/domain/usecases/update_task.dart';
import 'package:uuid/uuid.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

enum TaskFilter { all, done, undone, deleted }

class TaskBloc extends Bloc<TasksEvent, TasksState> {
  final GetAllTasksUseCase getAllTasks;
  final AddTaskUseCase addTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskBloc({
    required this.getAllTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TasksInitial()) {
    
    on<GetTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        //if (userId == null) throw Exception("User not authenticated");

        final querySnapshot = await _firestore
            .collection('tasks')
            .where('userId', isEqualTo: userId)
            .get();

        List<TaskEntity> tasks = querySnapshot.docs.map((doc) {
          return TaskEntity(
            id: doc['id'],
            userId: doc['userId'],
            title: doc['title'],
            description: doc['description'],
            date: (doc['date'] as Timestamp).toDate(),
            isDone: doc['isDone'],
            isDeleted: doc['isDeleted'],
          );
        }).toList();

        if (event.filter == TaskFilter.done ) {
          tasks =
              tasks.where((task) => task.isDone && !task.isDeleted).toList();
        } else if (event.filter == TaskFilter.undone) {
          tasks =
              tasks.where((task) => !task.isDone && !task.isDeleted).toList();
        } else if (event.filter == TaskFilter.deleted) {
          tasks = tasks.where((task) => task.isDeleted).toList();
        }else if (event.filter == TaskFilter.all) {
          tasks = tasks.where((task) => !task.isDeleted).toList();
        }

        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to fetch tasks: $e'));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) throw Exception("User not authenticated");

        final String id = Uuid().v4();
        TaskEntity task = TaskEntity(
          id: id,
          userId: userId,
          title: event.title,
          description: event.description,
          date: event.date,
          isDone: event.isDone,
          isDeleted: event.isDeleted,
        );

        await _firestore.collection('tasks').doc(id).set({
          'id': task.id,
          'userId': task.userId,
          'title': task.title,
          'description': task.description,
          'date': task.date,
          'isDone': task.isDone,
          'isDeleted': task.isDeleted,
        });

        add(GetTasksEvent(filter: TaskFilter.undone));
      } catch (e) {
        emit(TaskError(message: 'Failed to add task: $e'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        await _firestore.collection('tasks').doc(event.task.id).update({
          'title': event.task.title,
          'description': event.task.description,
          'date': event.task.date,
          'isDone': event.task.isDone,
          'isDeleted': event.task.isDeleted,
          'user': event.task.userId,
        });

        final querySnapshot = await _firestore
            .collection('tasks')
            .where('user', isEqualTo: event.task.userId)
            .get();

        List<TaskEntity> tasks = querySnapshot.docs.map((doc) {
          return TaskEntity(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            date: (doc['date'] as Timestamp).toDate(),
            isDone: doc['isDone'],
            isDeleted: doc['isDeleted'],
            userId: doc['user'],
          );
        }).toList();

        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to update task: $e'));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        await _firestore.collection('tasks').doc(event.task.id).update({
          'isDeleted': true,
          'user': event.task.userId,
        });

        final querySnapshot = await _firestore
            .collection('tasks')
            .where('user', isEqualTo: event.task.userId)
            .get();

        List<TaskEntity> tasks = querySnapshot.docs.map((doc) {
          return TaskEntity(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            date: (doc['date'] as Timestamp).toDate(),
            isDone: doc['isDone'],
            isDeleted: doc['isDeleted'],
            userId: doc['user'],
          );
        }).toList();

        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(message: 'Failed to delete task: $e'));
      }
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/core/firebase/firebase_service.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';

abstract class TaskDataSource {
  Future<QuerySnapshot<Object?>> getAllTasks();
  Future<DocumentReference<Object?>> addTask(TaskModel taskModel);
  Future<void> updateTask(TaskModel taskModel);
  Future<void> deleteTask(TaskModel taskModel);
}
 
class TaskDataSourceImpl extends TaskDataSource {
  final FirebaseService firebaseService;
 
  TaskDataSourceImpl(this.firebaseService);
 
  @override
  Future<DocumentReference<Object?>> addTask(TaskModel taskModel) {
    User currentUser = firebaseService.getAuth().currentUser!;
 
    CollectionReference userTasks = firebaseService
        .getFireStore()
        .collection('tasks-${currentUser.uid}');
    return userTasks.add(taskModel.toJson());
  }
 
  @override
  Future<void> updateTask(TaskModel taskModel) {
    User currentUser = firebaseService.getAuth().currentUser!;
 
    CollectionReference userTasks = firebaseService
        .getFireStore()
        .collection('tasks-${currentUser.uid}');
   
    return userTasks.doc(taskModel.id).update(taskModel.toJson());
 
  }
 
  @override
  Future<void> deleteTask(TaskModel taskModel) {
    User currentUser = firebaseService.getAuth().currentUser!;
 
    CollectionReference userTasks = firebaseService
        .getFireStore()
        .collection('tasks-${currentUser.uid}');
   
    return userTasks.doc(taskModel.id).delete();
 
  }
 
  @override
  Future<QuerySnapshot<Object?>> getAllTasks() {
    User currentUser = firebaseService.getAuth().currentUser!;
 
    CollectionReference userTasks = firebaseService
        .getFireStore()
        .collection('tasks-${currentUser.uid}');
   
    return userTasks.get();
 
 
  }
 
 
 
 
 
 
 
 
}
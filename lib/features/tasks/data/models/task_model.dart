import 'package:todo_app/features/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

class TaskModel extends TaskEntity {
  TaskModel(
      {required String id,
      required String title,
      required description,
      required DateTime date,
      isDone = false,
      isDeleted = false})
      : super(
            id: id,
            title: title,
            description: description,
            date: date,
            isDone: isDone,
            isDeleted: isDeleted);
 
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateFormat('d/m/y').parse(json['date']),
      isDone: json['isDone'],
      isDeleted: json['isDeleted'],
    );
  }
 
  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': DateFormat('d/m/y').format(date),
      'isDone': isDone,
      'isDeleted': isDeleted,
    };
  }
}
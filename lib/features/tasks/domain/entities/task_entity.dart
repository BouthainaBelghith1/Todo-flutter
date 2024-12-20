import 'package:equatable/equatable.dart';
 
class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;
  final bool isDeleted;
 
  const TaskEntity(
      {required this.id,
      required this.userId,
      required this.title,
      required this.description,
      required this.date,
      this.isDone = false,
      this.isDeleted = false});

  TaskEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isDone,
    DateTime? date,
    bool? isDeleted
  }) {
    return TaskEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      date: date ?? this.date,
      isDeleted: isDeleted ?? this.isDeleted
    );
  }
 
  @override
  List<Object?> get props => [id, title, description, date, isDone, isDeleted];
}
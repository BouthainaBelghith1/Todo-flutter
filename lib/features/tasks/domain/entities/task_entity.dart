import 'package:equatable/equatable.dart';
 
class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;
  final bool isDeleted;
 
  const TaskEntity(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      this.isDone = false,
      this.isDeleted = false});
 
  @override
  List<Object?> get props => [id, title, description, date, isDone, isDeleted];
}
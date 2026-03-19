import '../../domain/entities/task.dart';

class TaskModel extends Task {

  TaskModel({
    required int id,
    required String title,
    required bool completed,
  }) : super(id: id, title: title, completed: completed);

  factory TaskModel.fromJson(Map<String, dynamic> json) {

    return TaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "id": id,
      "title": title,
      "completed": completed,
    };
  }
}
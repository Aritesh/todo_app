import 'package:hive/hive.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';

class TaskLocalDatasource {

  final Box box;

  TaskLocalDatasource(this.box);

  Future<void> cacheTasks(List<TaskModel> tasks) async {

    final jsonList = tasks.map((e) => e.toJson()).toList();

    await box.put("tasks", jsonList);
  }

  List<TaskModel> getCachedTasks() {

    final data = box.get("tasks", defaultValue: []);

    return (data as List)
        .map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
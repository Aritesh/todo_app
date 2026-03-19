import '../entities/task.dart';

abstract class TaskRepository {

  Future<List<Task>> getTasks();

  Future<Task> addTask(String title);

  Future<void> deleteTask(int id);

  Future<Task> completeTask(int id,String title, bool isCompleted);
}
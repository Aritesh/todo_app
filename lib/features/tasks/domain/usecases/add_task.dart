import 'package:todo_app/features/tasks/domain/entities/task.dart';
import 'package:todo_app/features/tasks/domain/repository/task_repository.dart';

class AddTask {

  final TaskRepository repository;

  AddTask(this.repository);

  Future<Task> call(String title) {
    return repository.addTask(title);
  }
}
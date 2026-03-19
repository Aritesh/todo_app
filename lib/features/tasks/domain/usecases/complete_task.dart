import 'package:todo_app/features/tasks/domain/entities/task.dart';
import 'package:todo_app/features/tasks/domain/repository/task_repository.dart';

class CompleteTask {

  final TaskRepository repository;

  CompleteTask(this.repository);

  Future<Task> call(int id,String title, bool isCompleted) {
    return repository.completeTask(id,title,isCompleted);
  }
}
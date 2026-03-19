import 'package:todo_app/features/tasks/domain/repository/task_repository.dart';

class DeleteTask {

  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(int id) {
    return repository.deleteTask(id);
  }
}
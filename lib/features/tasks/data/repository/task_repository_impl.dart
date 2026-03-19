import 'package:flutter/material.dart';
import 'package:todo_app/features/tasks/data/datasource/task_local_datasource.dart';
import 'package:todo_app/features/tasks/data/datasource/task_remote_datasource.dart';
import 'package:todo_app/features/tasks/data/models/task_model.dart';
import 'package:todo_app/features/tasks/domain/entities/task.dart';
import 'package:todo_app/features/tasks/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {

  final TaskRemoteDatasource remote;
  final TaskLocalDatasource local;

  TaskRepositoryImpl(this.remote, this.local);

  @override
  Future<List<Task>> getTasks() async {

    try {

      final remoteTasks = await remote.getTodos();

      await local.cacheTasks(remoteTasks);

      return remoteTasks;

    } catch (_) {

      return local.getCachedTasks();
    }
  }

  @override
  Future<Task> addTask(String title) async {

    return TaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: false,
    );
  }

  @override
  Future<void> deleteTask(int id) async {}

  @override
  Future<Task> completeTask(int id, String title,bool isCompleted) async {

    return TaskModel(id: id, title: title, completed: isCompleted);
  }
}
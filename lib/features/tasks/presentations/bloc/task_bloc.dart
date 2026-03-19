import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/complete_task.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final GetTasks getTasks;
  final AddTask addTask;
  final DeleteTask deleteTask;
  final CompleteTask completeTask;

  List<Task> allTasks = [];

  TaskBloc(
    this.getTasks,
    this.addTask,
    this.deleteTask,
    this.completeTask,
  ) : super(TaskInitial()) {

    /// ✅ LOAD TASKS
    on<LoadTasks>((event, emit) async {

      emit(TaskLoading());

      try {
        final tasks = await getTasks();

        allTasks = tasks;

        emit(TaskLoaded(tasks));

      } catch (e) {
        emit(TaskError("Failed to load tasks"));
      }
    });

    /// ✅ ADD TASK
    on<AddTaskEvent>((event, emit) async {

      try {
        final newTask = await addTask(event.title);

        allTasks.insert(0, newTask);

        emit(TaskLoaded(List.from(allTasks)));

      } catch (e) {
        emit(TaskError("Failed to add task"));
      }
    });

    /// ✅ DELETE TASK
    on<DeleteTaskEvent>((event, emit) async {

      try {
        await deleteTask(event.id);

        allTasks.removeWhere((t) => t.id == event.id);

        emit(TaskLoaded(List.from(allTasks)));

      } catch (e) {
        emit(TaskError("Failed to delete task"));
      }
    });

    /// ✅ COMPLETE TASK (FIXED ERROR HERE)
    on<CompleteTaskEvent>((event, emit) async {

      try {
        final updatedTask = await completeTask(event.id,event.title, event.isCompleted);


        final index = allTasks.indexWhere((t) => t.id == event.id);

        if (index != -1) {
          allTasks[index] = updatedTask;
        }

        emit(TaskLoaded(List.from(allTasks)));

      } catch (e) {
        emit(TaskError("Failed to update task"));
      }
    });

    /// ✅ SEARCH TASK
    on<SearchTaskEvent>((event, emit) {

      final filtered = allTasks
          .where((task) => task.title
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();

      emit(TaskLoaded(filtered));
    });
  }
}
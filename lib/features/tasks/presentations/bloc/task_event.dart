abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;

  AddTaskEvent(this.title);
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  DeleteTaskEvent(this.id);
}

class CompleteTaskEvent extends TaskEvent {
  final int id;
  final String title;
  final bool isCompleted;

  CompleteTaskEvent(this.id,this.title,this.isCompleted);
}

class SearchTaskEvent extends TaskEvent {
  final String query;

  SearchTaskEvent(this.query);
}
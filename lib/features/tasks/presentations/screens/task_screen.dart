import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load tasks initially
    context.read<TaskBloc>().add(LoadTasks());
  }

  void _showAddTaskDialog() {

    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter task title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {

                if (controller.text.trim().isNotEmpty) {

                  context.read<TaskBloc>().add(
                        AddTaskEvent(controller.text.trim()),
                      );

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<TaskBloc>().add(LoadTasks());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                context.read<TaskBloc>().add(
                      SearchTaskEvent(value),
                    );
              },
            ),
          ),

          /// 📋 Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {

                if (state is TaskLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is TaskError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is TaskLoaded) {

                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text("No tasks found"),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {

                        final task = state.tasks[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(

                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),

                            leading: Checkbox(
                              value: task.completed,
                              onChanged: (value) {
                                print("_______________uuuuuu_____");
                                context.read<TaskBloc>().add(
                                      CompleteTaskEvent(task.id,task.title, value ?? false),
                                    );
                              },
                            ),

                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<TaskBloc>().add(
                                      DeleteTaskEvent(task.id),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Task deleted"),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text("Start by adding tasks"),
                );
              },
            ),
          ),
        ],
      ),

      /// ➕ Add Task Button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
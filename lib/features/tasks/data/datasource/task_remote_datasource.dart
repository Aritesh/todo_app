

import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:todo_app/features/tasks/data/models/task_model.dart';

class TaskRemoteDatasource {

  final http.Client client;

  TaskRemoteDatasource(this.client);

  Future<List<TaskModel>> getTodos() async {

    final response = await client.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos"),
    );

    final data = json.decode(response.body) as List;

    return data.map((e) => TaskModel.fromJson(e)).toList();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_app/features/tasks/presentations/bloc/task_bloc.dart';
import 'package:todo_app/features/tasks/presentations/bloc/task_event.dart';
import 'package:todo_app/features/tasks/presentations/screens/task_screen.dart';
import 'core/di/injection_container.dart' as di;


final sl = GetIt.instance;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('taskBox');
  await di.init(box);

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(

      providers: [

        BlocProvider<TaskBloc>(
          create: (_) => di.sl<TaskBloc>()..add(LoadTasks()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Task App',

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        home: const TaskScreen(),
      ),
    );
  }
}
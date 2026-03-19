import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:todo_app/features/tasks/data/repository/task_repository_impl.dart';
import 'package:todo_app/features/tasks/domain/repository/task_repository.dart';
import 'package:todo_app/features/tasks/presentations/bloc/task_bloc.dart';

// Data Sources
import '../../features/tasks/data/datasource/task_remote_datasource.dart';
import '../../features/tasks/data/datasource/task_local_datasource.dart';

// UseCases
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/domain/usecases/add_task.dart';
import '../../features/tasks/domain/usecases/delete_task.dart';
import '../../features/tasks/domain/usecases/complete_task.dart';


final sl = GetIt.instance;

Future<void> init(Box box) async {

  /// 🔹 External
  sl.registerLazySingleton(() => http.Client());

  /// 🔹 Data Sources
  sl.registerLazySingleton(
    () => TaskRemoteDatasource(sl()),
  );

  sl.registerLazySingleton(
    () => TaskLocalDatasource(box),
  );

  /// 🔹 Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl(), sl()),
  );

  /// 🔹 UseCases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => CompleteTask(sl()));

  /// 🔹 Bloc
  sl.registerFactory(
    () => TaskBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}
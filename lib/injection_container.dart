
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo_app/core/firebase/firebase_service.dart';
import 'package:todo_app/core/network/network_info.dart';
import 'package:todo_app/features/auth/data/datasources/user_data_source.dart';
import 'package:todo_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:todo_app/features/auth/domain/repositories/user_repository.dart';
import 'package:todo_app/features/auth/domain/usecases/register_user.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_user.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_out_user.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo_app/features/auth/presentation/bloc/user_manager/user_manager_bloc.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/features/tasks/data/datasources/task_data_source.dart';
import 'package:todo_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:todo_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:todo_app/features/tasks/domain/usecases/add_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/delete_task.dart';
import 'package:todo_app/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:todo_app/features/tasks/domain/usecases/update_task.dart';
import 'package:todo_app/features/tasks/presentation/blocs/bloc/tasks_bloc.dart';
import 'package:todo_app/navigation/app_router.dart';

final sl = GetIt.instance;//sl: service Locator
 
Future<void> init() async {
  //Service Locator for all components
 
  // find and instanciate SwitchthemeBloc
  sl.registerLazySingleton(() => SwitchThemeBloc());
 
  // find and instanciate AppRouter
  sl.registerLazySingleton(() => AppRouter(sl()));

  //Firebase Service
  final firebaseService = await FirebaseService.init();
  sl.registerLazySingleton(() => firebaseService);

  // Feature auth (register + auth)
  // RegisterBloc
  sl.registerLazySingleton(() => UserManagerBloc(registerUserUseCase: sl()));
  sl.registerLazySingleton(() => AuthBloc(
        signInUserUseCase: sl(),
        signOutUserUseCase: sl(),
        firebaseService: sl(),
        
      ));
 
  // Usecases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl()));
 
  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userDataSource: sl(), networkInfo: sl()));
 
  // Datasources
  sl.registerLazySingleton<UserDataSource>(
      () => UserDataSourceImpl(firebaseService: sl()));
 
  // Core
  sl.registerLazySingleton<NetwortkInfo>(() => NetwortkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Feature tasks
  // Datasource for tasks

  sl.registerLazySingleton<TaskDataSource>(
    () => TaskDataSourceImpl(sl()));

  // Repository for tasks
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(taskDataSource: sl(), networtkInfo: sl()));

  // Usecases for tasks
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

  // Bloc for tasks
  sl.registerFactory(() => TaskBloc(
        getAllTasks: sl(),
        addTask: sl(),
        updateTask: sl(),
        deleteTask: sl(),
      ));
}
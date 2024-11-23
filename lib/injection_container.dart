
import 'package:get_it/get_it.dart';
import 'package:todo_app/core/firebase/firebase_service.dart';
import 'package:todo_app/features/home/presentation/blocs/switch_theme/switch_theme_bloc.dart';
import 'package:todo_app/navigation/app_router.dart';

final sl = GetIt.instance;//sl: service Locator
 
Future<void> init() async {
  //Service Locator for all components
 
  // find and instanciate SwitchthemeBloc
  sl.registerLazySingleton(() => SwitchThemeBloc());
 
  // find and instanciate AppRouter
  sl.registerLazySingleton(() => AppRouter());

  //Firebase Service
  final firebaseService = await FirebaseService.init();
  sl.registerLazySingleton(() => firebaseService);
}
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final firebaseApp = await Firebase.initializeApp();

  final remoteConfig = await RemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

  sl.registerLazySingleton(() => firebaseApp);
  sl.registerLazySingleton(() => remoteConfig);
}

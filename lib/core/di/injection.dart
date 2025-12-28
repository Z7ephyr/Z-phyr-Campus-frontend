import 'package:get_it/get_it.dart';
import '../api/api_client.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core
  getIt.registerLazySingleton(() => SecureStorageService());
  getIt.registerLazySingleton(() => ApiClient(getIt()));

  // Auth
  getIt.registerLazySingleton(() => AuthRemoteDataSource(getIt()));
  getIt.registerFactory(() => AuthBloc(getIt(), getIt()));
}
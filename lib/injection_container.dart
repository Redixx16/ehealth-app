import 'package:get_it/get_it.dart';
// Rutas corregidas (ahora son relativas)
import 'package:ehealth_app/data/datasources/patient_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/patient_remote_data_source_impl.dart';
import 'package:ehealth_app/data/datasources/gamification_remote_data_source.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';
import 'package:ehealth_app/data/repositories/patient_repository_impl.dart';
import 'package:ehealth_app/data/repositories/gamification_repository_impl.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/auth_remote_data_source.dart';
import 'presentation/bloc/login/login_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // --- REGISTRO DE DEPENDENCIAS ---

  // DataSources
  locator.registerLazySingleton(() => AuthRemoteDataSource());

  // BLoCs
  locator.registerFactory(
    () => LoginBloc(
      authRemoteDataSource: locator<AuthRemoteDataSource>(),
    ),
  );

  // Patient
  locator.registerFactory(() => PatientBloc(patientRepository: locator()));

  // Gamification
  locator.registerFactory(() => GamificationBloc(gamificationRepository: locator()));

  locator.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(remoteDataSource: locator()),
  );

  locator.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(client: locator()),
  );

  locator.registerLazySingleton<GamificationRepository>(
    () => GamificationRepositoryImpl(remoteDataSource: locator()),
  );

  locator.registerLazySingleton<GamificationRemoteDataSource>(
    () => GamificationRemoteDataSourceImpl(client: locator()),
  );

  locator.registerLazySingleton(() => http.Client());
}

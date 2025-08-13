// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// DataSources
import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/patient_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/patient_remote_data_source_impl.dart';
import 'package:ehealth_app/data/datasources/gamification_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';

// Repositories
import 'package:ehealth_app/domain/repositories/patient_repository.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';
import 'package:ehealth_app/data/repositories/patient_repository_impl.dart';
import 'package:ehealth_app/data/repositories/gamification_repository_impl.dart';

// BLoCs
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/update_appointment/update_appointment_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // --- BLoCs ---
  locator.registerFactory(() => LoginBloc(authRemoteDataSource: locator()));
  locator.registerFactory(() => PatientBloc(patientRepository: locator()));
  locator.registerFactory(
      () => GamificationBloc(gamificationRepository: locator()));
  locator.registerFactory(
      () => AppointmentsBloc(appointmentDataSource: locator()));
  locator.registerFactory(
      () => CreateAppointmentBloc(appointmentDataSource: locator()));
  locator.registerFactory(() => DeleteAppointmentBloc(dataSource: locator()));
  locator.registerFactory(() => UpdateAppointmentBloc(dataSource: locator()));

  // --- REPOSITORIES ---
  locator.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<GamificationRepository>(
    () => GamificationRepositoryImpl(remoteDataSource: locator()),
  );

  // --- DATA SOURCES ---
  locator.registerLazySingleton(() => AuthRemoteDataSource());
  locator.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<GamificationRemoteDataSource>(
    () => GamificationRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton(() => AppointmentRemoteDataSource());

  // --- EXTERNAL ---
  locator.registerLazySingleton(() => http.Client());
}

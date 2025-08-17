// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Core
import 'package:ehealth_app/core/api/api_client.dart';

// UseCases
import 'package:ehealth_app/domain/usecases/create_patient.dart';
import 'package:ehealth_app/domain/usecases/get_patient.dart';
import 'package:ehealth_app/domain/usecases/appointments/create_appointment.dart';
import 'package:ehealth_app/domain/usecases/appointments/delete_appointment.dart';
import 'package:ehealth_app/domain/usecases/appointments/get_appointments.dart';
import 'package:ehealth_app/domain/usecases/appointments/update_appointment.dart';
import 'package:ehealth_app/domain/usecases/gamification/add_points.dart';
import 'package:ehealth_app/domain/usecases/gamification/check_and_award_achievements.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_achievements.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_pregnancy_milestones.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_user_progress.dart';
import 'package:ehealth_app/domain/usecases/gamification/increment_appointment_attendance.dart';
import 'package:ehealth_app/domain/usecases/notifications/get_notifications.dart';
import 'package:ehealth_app/domain/usecases/notifications/mark_all_notifications_as_read.dart';
import 'package:ehealth_app/domain/usecases/notifications/mark_notification_as_read.dart';

// DataSources
import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/patient_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/patient_remote_data_source_impl.dart';
import 'package:ehealth_app/data/datasources/gamification_remote_data_source.dart';
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';

// Repositories
import 'package:ehealth_app/domain/repositories/patient_repository.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';
import 'package:ehealth_app/domain/repositories/notification_repository.dart';
import 'package:ehealth_app/data/repositories/patient_repository_impl.dart';
import 'package:ehealth_app/data/repositories/gamification_repository_impl.dart';
import 'package:ehealth_app/data/repositories/appointment_repository_impl.dart';
import 'package:ehealth_app/data/repositories/notification_repository_impl.dart';

// BLoCs
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/update_appointment/update_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/register/register_bloc.dart';
import 'package:ehealth_app/presentation/bloc/notifications/notification_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // ================== CORRECCIÓN CLAVE ==================
  // --- CORE ---
  // Registramos el ApiClient para que pueda ser inyectado en los DataSources.
  locator.registerLazySingleton(() => ApiClient(client: locator()));
  // ======================================================

  // --- USE CASES ---
  locator.registerLazySingleton(() => GetPatientUseCase(locator()));
  locator.registerLazySingleton(() => CreatePatientUseCase(locator()));
  locator.registerLazySingleton(() => GetAppointmentsUseCase(locator()));
  locator.registerLazySingleton(() => CreateAppointmentUseCase(locator()));
  locator.registerLazySingleton(() => UpdateAppointmentUseCase(locator()));
  locator.registerLazySingleton(() => DeleteAppointmentUseCase(locator()));
  locator.registerLazySingleton(() => GetUserProgressUseCase(locator()));
  locator.registerLazySingleton(() => GetAchievementsUseCase(locator()));
  locator.registerLazySingleton(() => GetPregnancyMilestonesUseCase(locator()));
  locator.registerLazySingleton(
      () => IncrementAppointmentAttendanceUseCase(locator()));
  locator
      .registerLazySingleton(() => CheckAndAwardAchievementsUseCase(locator()));
  locator.registerLazySingleton(() => AddPointsUseCase(locator()));
  locator.registerLazySingleton(() => GetNotificationsUseCase(locator()));
  locator.registerLazySingleton(() => MarkNotificationAsReadUseCase(locator()));
  locator.registerLazySingleton(
      () => MarkAllNotificationsAsReadUseCase(locator()));

  // --- BLOCS ---
  locator.registerFactory(() => LoginBloc(authRemoteDataSource: locator()));
  locator.registerFactory(() => RegisterBloc(authRemoteDataSource: locator()));
  locator.registerFactory(() => PatientBloc(
        getPatientUseCase: locator(),
        createPatientUseCase: locator(),
      ));
  locator.registerFactory(() => GamificationBloc(
        getUserProgressUseCase: locator(),
        getAchievementsUseCase: locator(),
        getPregnancyMilestonesUseCase: locator(),
        incrementAppointmentAttendanceUseCase: locator(),
        checkAndAwardAchievementsUseCase: locator(),
        addPointsUseCase: locator(),
      ));
  locator.registerFactory(() => NotificationBloc(
        getNotificationsUseCase: locator(),
        markNotificationAsReadUseCase: locator(),
        markAllNotificationsAsReadUseCase: locator(),
      ));
  locator.registerFactory(
      () => AppointmentsBloc(getAppointmentsUseCase: locator()));
  locator.registerFactory(
      () => CreateAppointmentBloc(createAppointmentUseCase: locator()));
  locator.registerFactory(
      () => UpdateAppointmentBloc(updateAppointmentUseCase: locator()));
  locator.registerFactory(
      () => DeleteAppointmentBloc(deleteAppointmentUseCase: locator()));

  // --- REPOSITORIES ---
  locator.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<GamificationRepository>(
    () => GamificationRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: locator()),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: locator()),
  );

  // --- DATA SOURCES ---
  locator
      .registerLazySingleton(() => AuthRemoteDataSource(apiClient: locator()));
  locator.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(apiClient: locator()),
  );
  locator.registerLazySingleton<GamificationRemoteDataSource>(
    () => GamificationRemoteDataSourceImpl(apiClient: locator()),
  );
  locator.registerLazySingleton(
      () => AppointmentRemoteDataSource(apiClient: locator()));

  // --- EXTERNAL ---
  locator.registerLazySingleton(() => http.Client());
}

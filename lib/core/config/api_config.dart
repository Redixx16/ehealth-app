import 'package:ehealth_app/core/config/environment_config.dart';

class ApiConfig {
  // Configuración centralizada de la API
  static String get baseUrl => EnvironmentConfig.baseUrl;

  // Timeouts
  static Duration get connectionTimeout =>
      Duration(seconds: EnvironmentConfig.timeout);
  static Duration get receiveTimeout =>
      Duration(seconds: EnvironmentConfig.timeout);

  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  // Endpoints base
  static const String authEndpoint = '/auth';
  static const String patientsEndpoint = '/patients';
  static const String appointmentsEndpoint = '/appointments';
  static const String gamificationEndpoint = '/gamification';

  // URL completa para endpoints específicos
  static String get loginUrl => '$baseUrl$authEndpoint/login';
  static String get registerUrl => '$baseUrl$authEndpoint/register';
  static String get allPatientsUrl => '$baseUrl$patientsEndpoint';

  // Esta era la URL que causaba el error "No host specified"
  static String get createPatientProfileUrl => '$baseUrl$patientsEndpoint';

  static String get patientMeUrl => '$baseUrl$patientsEndpoint/profile';
  static String get registerPatientUrl =>
      '$baseUrl$patientsEndpoint/register-patient';
  static String get appointmentsUrl => '$baseUrl$appointmentsEndpoint';
  static String get achievementsUrl =>
      '$baseUrl$gamificationEndpoint/achievements';
  static String get userProgressUrl =>
      '$baseUrl$gamificationEndpoint/user-progress/me';
  static String get userProgressAddPointsUrl =>
      '$baseUrl$gamificationEndpoint/user-progress/add-points';
  static String get userProgressIncrementAppointmentUrl =>
      '$baseUrl$gamificationEndpoint/user-progress/increment-appointment';
  static String get pregnancyMilestonesUrl =>
      '$baseUrl$gamificationEndpoint/pregnancy-milestones';
  static String get notificationsUrl =>
      '$baseUrl$gamificationEndpoint/notifications/me';
  static String get unreadNotificationsUrl =>
      '$baseUrl$gamificationEndpoint/notifications/me/unread';
  static String get markAllNotificationsReadUrl =>
      '$baseUrl$gamificationEndpoint/notifications/me/read-all';
  static String get checkAchievementsUrl =>
      '$baseUrl$gamificationEndpoint/check-achievements';
  static String get dashboardUrl => '$baseUrl$gamificationEndpoint/dashboard';

  // Métodos para URLs con parámetros
  static String getAppointmentUrl(int id) =>
      '$baseUrl$appointmentsEndpoint/$id';
  static String getNotificationReadUrl(int notificationId) =>
      '$baseUrl$gamificationEndpoint/notifications/$notificationId/read';
}

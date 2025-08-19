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

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String patientsEndpoint = '/patients';
  static const String appointmentsEndpoint = '/appointments';
  static const String gamificationEndpoint = '/gamification';

  // Métodos para construir URLs completas
  static String getAuthUrl(String endpoint) => '$baseUrl$authEndpoint$endpoint';
  static String getPatientsUrl(String endpoint) =>
      '$baseUrl$patientsEndpoint$endpoint';
  static String getAppointmentsUrl(String endpoint) =>
      '$baseUrl$appointmentsEndpoint$endpoint';
  static String getGamificationUrl(String endpoint) =>
      '$baseUrl$gamificationEndpoint$endpoint';

  // URL completa para endpoints específicos
  static String get loginUrl => getAuthUrl('/login');
  static String get registerUrl => getAuthUrl('/register');
  static String get allPatientsUrl => getPatientsUrl('');
  static String get patientMeUrl => getPatientsUrl('/me');
  static String get appointmentsUrl => getAppointmentsUrl('');
  static String get achievementsUrl => getGamificationUrl('/achievements');
  static String get userProgressUrl => getGamificationUrl('/user-progress/me');
  static String get userProgressAddPointsUrl =>
      getGamificationUrl('/user-progress/add-points');
  static String get userProgressIncrementAppointmentUrl =>
      getGamificationUrl('/user-progress/increment-appointment');
  static String get pregnancyMilestonesUrl =>
      getGamificationUrl('/pregnancy-milestones');
  static String get notificationsUrl => getGamificationUrl('/notifications/me');
  static String get unreadNotificationsUrl =>
      getGamificationUrl('/notifications/me/unread');
  static String get markAllNotificationsReadUrl =>
      getGamificationUrl('/notifications/me/read-all');
  static String get checkAchievementsUrl =>
      getGamificationUrl('/check-achievements');
  static String get dashboardUrl => getGamificationUrl('/dashboard');

  // Métodos para URLs con parámetros
  static String getAppointmentUrl(int id) => getAppointmentsUrl('/$id');
  static String getNotificationReadUrl(int notificationId) =>
      getGamificationUrl('/notifications/$notificationId/read');
}

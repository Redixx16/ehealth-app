// lib/data/services/notification_service.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    print("NOTIFICATION_SERVICE: Servicio inicializado.");
    await _requestNotificationPermissions();
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    await _notificationsPlugin.initialize(initializationSettings);
    await _setupNotificationChannels();
  }

  Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
      'general_notifications', // ID del nuevo canal
      'Alertas y Consejos', // Nombre del canal
      description: 'Notificaciones generales, consejos de salud y logros.',
      importance: Importance.max,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);
  }

  Future<void> _requestNotificationPermissions() async {
    await Permission.notification.request();
  }

  // ================== FUNCIÓN NUEVA ==================
  // Muestra una notificación instantánea de alta prioridad
  Future<void> showInstantNotification(
      {required int id, required String title, required String body}) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'general_notifications', // Usa el ID del nuevo canal
        'Alertas y Consejos',
        channelDescription:
            'Notificaciones generales, consejos de salud y logros.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
  // =========================================================

  Future<void> scheduleAppointmentNotification(Appointment appointment) async {
    final reminderDate =
        appointment.appointmentDate.subtract(const Duration(days: 1));
    if (reminderDate.isBefore(DateTime.now())) return;

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(reminderDate, tz.local);

    // ================== CORRECCIÓN CLAVE 2 ==================
    // Mejoramos los detalles de la notificación para que tenga sonido y prioridad
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'appointment_reminders',
        'Recordatorios de Citas',
        channelDescription: 'Recordatorios para citas prenatales',
        importance: Importance.max, // Prioridad máxima
        priority: Priority.high, // Notificación emergente (heads-up)
        playSound: true,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true, // Habilitar sonido en iOS
      ),
    );
    // =========================================================

    await _notificationsPlugin.zonedSchedule(
      appointment.id,
      'Recordatorio de Cita Prenatal',
      'Tienes una cita mañana a las ${DateFormat('hh:mm a').format(appointment.appointmentDate)}. ¡No olvides asistir!',
      scheduledDate,
      notificationDetails, // Usamos los nuevos detalles
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Notificación de hito del embarazo
  Future<void> schedulePregnancyMilestoneNotification(
      String milestone, DateTime date) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(date, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      date.millisecondsSinceEpoch ~/ 1000,
      '¡Hito del Embarazo!',
      milestone,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pregnancy_milestones',
          'Hitos del Embarazo',
          channelDescription: 'Notificaciones sobre el progreso del embarazo',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Notificación de logro/achievement
  Future<void> showAchievementNotification(String title, String message) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'Logros y Puntos',
          channelDescription: 'Notificaciones de logros y sistema de puntos',
          importance: Importance.low,
          priority: Priority.low,
          icon: 'ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // Notificación inmediata de recordatorio de medicamentos
  Future<void> showMedicationReminder(String medication, String time) async {
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Recordatorio de Medicamento',
      'Es hora de tomar: $medication ($time)',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appointment_reminders',
          'Recordatorios de Citas',
          channelDescription: 'Recordatorios para citas prenatales',
          importance: Importance.high,
          priority: Priority.high,
          icon: 'ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

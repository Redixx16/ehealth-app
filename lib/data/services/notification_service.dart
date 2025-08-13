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
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();
    await _notificationsPlugin.initialize(initializationSettings);
    
    // Configurar canales de notificación
    await _setupNotificationChannels();
  }

  Future<void> _setupNotificationChannels() async {
    // Canal para recordatorios de citas
    const AndroidNotificationChannel appointmentChannel = AndroidNotificationChannel(
      'appointment_reminders',
      'Recordatorios de Citas',
      description: 'Recordatorios para citas prenatales',
      importance: Importance.high,
    );

    // Canal para hitos del embarazo
    const AndroidNotificationChannel milestoneChannel = AndroidNotificationChannel(
      'pregnancy_milestones',
      'Hitos del Embarazo',
      description: 'Notificaciones sobre el progreso del embarazo',
      importance: Importance.defaultImportance,
    );

    // Canal para logros y puntos
    const AndroidNotificationChannel achievementChannel = AndroidNotificationChannel(
      'achievements',
      'Logros y Puntos',
      description: 'Notificaciones de logros y sistema de puntos',
      importance: Importance.low,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(appointmentChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(milestoneChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(achievementChannel);
  }

  Future<void> _requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("Permiso de notificaciones concedido");
    } else if (status.isDenied) {
      print("Permiso de notificaciones denegado");
    } else if (status.isPermanentlyDenied) {
      print("Permiso de notificaciones denegado permanentemente");
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Notificación de recordatorio de cita (mejorada)
  Future<void> scheduleAppointmentNotification(Appointment appointment) async {
    final appointmentDate = appointment.appointmentDate;
    final now = DateTime.now();
    
    // Programar notificación 1 día antes
    final reminderDate = appointmentDate.subtract(const Duration(days: 1));
    
    if (reminderDate.isBefore(now)) {
      return; // La cita ya pasó o es muy pronto
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(reminderDate, tz.local);

    await _notificationsPlugin.zonedSchedule(
      appointment.id,
      'Recordatorio de Cita Prenatal',
      'Tienes una cita mañana a las ${DateFormat('hh:mm a').format(appointmentDate)}. ¡No olvides asistir!',
      scheduledDate,
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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Notificación de hito del embarazo
  Future<void> schedulePregnancyMilestoneNotification(String milestone, DateTime date) async {
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

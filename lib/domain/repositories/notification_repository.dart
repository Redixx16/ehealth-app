// lib/domain/repositories/notification_repository.dart
import 'package:ehealth_app/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications();
  Future<Notification> markNotificationAsRead(int notificationId);
  Future<void> markAllNotificationsAsRead();
}

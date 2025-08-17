// lib/domain/usecases/notifications/mark_notification_as_read.dart
import 'package:ehealth_app/domain/entities/notification.dart';
import 'package:ehealth_app/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<Notification> execute(int notificationId) {
    return repository.markNotificationAsRead(notificationId);
  }
}

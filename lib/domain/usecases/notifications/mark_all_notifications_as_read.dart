// lib/domain/usecases/notifications/mark_all_notifications_as_read.dart
import 'package:ehealth_app/domain/repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<void> execute() {
    return repository.markAllNotificationsAsRead();
  }
}

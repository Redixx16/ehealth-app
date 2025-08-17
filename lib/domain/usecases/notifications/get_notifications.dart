// lib/domain/usecases/notifications/get_notifications.dart
import 'package:ehealth_app/domain/entities/notification.dart';
import 'package:ehealth_app/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<Notification>> execute() {
    return repository.getNotifications();
  }
}

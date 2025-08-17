// lib/data/repositories/notification_repository_impl.dart
import 'package:ehealth_app/data/datasources/gamification_remote_data_source.dart';
import 'package:ehealth_app/domain/entities/notification.dart';
import 'package:ehealth_app/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final GamificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Notification>> getNotifications() {
    return remoteDataSource.getNotifications();
  }

  @override
  Future<void> markAllNotificationsAsRead() {
    return remoteDataSource.markAllNotificationsAsRead();
  }

  @override
  Future<Notification> markNotificationAsRead(int notificationId) {
    return remoteDataSource.markNotificationAsRead(notificationId);
  }
}

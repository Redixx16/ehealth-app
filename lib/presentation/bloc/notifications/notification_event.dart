// lib/presentation/bloc/notifications/notification_event.dart
part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkOneAsRead extends NotificationEvent {
  final int notificationId;
  const MarkOneAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {}

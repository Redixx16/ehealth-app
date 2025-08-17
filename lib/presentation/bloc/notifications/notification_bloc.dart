// lib/presentation/bloc/notifications/notification_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:ehealth_app/domain/entities/notification.dart';
import 'package:ehealth_app/domain/usecases/notifications/get_notifications.dart';
import 'package:ehealth_app/domain/usecases/notifications/mark_all_notifications_as_read.dart';
import 'package:ehealth_app/domain/usecases/notifications/mark_notification_as_read.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkOneAsRead>(_onMarkOneAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await getNotificationsUseCase.execute();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkOneAsRead(
    MarkOneAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markNotificationAsReadUseCase.execute(event.notificationId);
      add(LoadNotifications()); // Recarga la lista
    } catch (e) {
      // Opcional: emitir un estado de error específico para esta acción
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await markAllNotificationsAsReadUseCase.execute();
      add(LoadNotifications()); // Recarga la lista
    } catch (e) {
      // Opcional: emitir un estado de error específico
    }
  }
}

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
    final currentState = state;
    if (currentState is NotificationLoaded) {
      // 1. Actualización Optimista: Actualiza la UI al instante
      final optimisticList = currentState.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(
              isRead: true); // Usa copyWith para crear un nuevo objeto
        }
        return n;
      }).toList();

      emit(NotificationLoaded(optimisticList));

      // 2. Llama a la API en segundo plano
      try {
        await markNotificationAsReadUseCase.execute(event.notificationId);
        // Opcional: Podrías recargar desde el servidor para consistencia total,
        // pero con la actualización optimista no suele ser necesario.
        // add(LoadNotifications());
      } catch (e) {
        // 3. Si falla la API, revierte el cambio en la UI
        emit(
            NotificationError('No se pudo marcar como leída. Reintentando...'));
        emit(currentState); // Vuelve al estado original
      }
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      // 1. Actualización Optimista
      final optimisticList = currentState.notifications.map((n) {
        return n.copyWith(isRead: true);
      }).toList();
      emit(NotificationLoaded(optimisticList));

      // 2. Llama a la API
      try {
        await markAllNotificationsAsReadUseCase.execute();
      } catch (e) {
        // 3. Revierte si falla
        emit(NotificationError('No se pudo marcar todo como leído.'));
        emit(currentState);
      }
    }
  }
}

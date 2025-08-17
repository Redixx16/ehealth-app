// lib/presentation/screens/patient/gamification/notifications_screen.dart
import 'package:ehealth_app/presentation/bloc/notifications/notification_bloc.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ehealth_app/domain/entities/notification.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Casos de Carga e Inicial
          if (state is NotificationInitial || state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Caso de Éxito
          if (state is NotificationLoaded) {
            final unreadCount =
                state.notifications.where((n) => !n.isRead).length;
            return Column(
              children: [
                _buildHeader(context, unreadCount),
                Expanded(
                  child: state.notifications.isEmpty
                      ? _buildEmptyState()
                      : _buildNotificationsList(state.notifications),
                ),
              ],
            );
          }
          // Caso de Error
          if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Caso por Defecto
          return const Center(child: Text('Algo salió mal.'));
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int unreadCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryLightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tus Alertas',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unreadCount > 0
                      ? '$unreadCount nueva${unreadCount > 1 ? 's' : ''}'
                      : 'Todo al día',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(
              onPressed: () =>
                  context.read<NotificationBloc>().add(MarkAllAsRead()),
              child: Text(
                'Marcar todas',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<Notification> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(context, notification);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'Sin notificaciones',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí aparecerán tus recordatorios y alertas.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, Notification notification) {
    return Card(
      elevation: 2,
      shadowColor: kPrimaryColor.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: notification.isRead ? Colors.transparent : kPrimaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: _buildNotificationIcon(notification.type),
        title: Text(
          notification.title,
          style: GoogleFonts.poppins(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
            color: kTextColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            notification.message,
            style: GoogleFonts.poppins(color: Colors.grey.shade600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          _formatTimeAgo(notification.createdAt!),
          style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 12),
        ),
        onTap: () {
          if (!notification.isRead) {
            context
                .read<NotificationBloc>()
                .add(MarkOneAsRead(notification.id));
          }
        },
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.APPOINTMENT_REMINDER:
        icon = Icons.calendar_month_outlined;
        color = kPrimaryColor;
        break;
      case NotificationType.ACHIEVEMENT_UNLOCKED:
        icon = Icons.emoji_events_outlined;
        color = Colors.amber.shade700;
        break;
      case NotificationType.MILESTONE_ACHIEVED:
        icon = Icons.flag_outlined;
        color = Colors.green.shade600;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.blue.shade600;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }
}

// lib/domain/entities/notification.dart
import 'package:equatable/equatable.dart';

// Enum actualizado para coincidir 100% con el backend
enum NotificationType {
  APPOINTMENT_REMINDER,
  MILESTONE_ACHIEVED,
  ACHIEVEMENT_UNLOCKED,
  HEALTH_TIP,
  EDUCATIONAL_CONTENT,
  SYSTEM_UPDATE,
  UNKNOWN // Un valor por defecto para seguridad
}

enum NotificationPriority { LOW, MEDIUM, HIGH, URGENT }

class Notification extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final bool isSent;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? actionData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.isSent,
    this.scheduledAt,
    this.sentAt,
    this.metadata,
    this.actionData,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    // Función segura para convertir string a enum
    NotificationType getType(String? typeStr) {
      switch (typeStr) {
        case 'appointment_reminder':
          return NotificationType.APPOINTMENT_REMINDER;
        case 'milestone_achieved':
          return NotificationType.MILESTONE_ACHIEVED;
        case 'achievement_unlocked':
          return NotificationType.ACHIEVEMENT_UNLOCKED;
        case 'health_tip':
          return NotificationType.HEALTH_TIP;
        case 'educational_content':
          return NotificationType.EDUCATIONAL_CONTENT;
        case 'system_update':
          return NotificationType.SYSTEM_UPDATE;
        default:
          return NotificationType.UNKNOWN;
      }
    }

    return Notification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: getType(json['type']),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name.toLowerCase() == json['priority'],
        orElse: () => NotificationPriority.MEDIUM,
      ),
      isRead: json['isRead'] ?? false,
      isSent: json['isSent'] ?? false,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      metadata: json['metadata'],
      actionData: json['actionData'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // MÉTODO AÑADIDO
  Notification copyWith({
    int? id,
    int? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    bool? isSent,
    DateTime? scheduledAt,
    DateTime? sentAt,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? actionData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      isSent: isSent ?? this.isSent,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      sentAt: sentAt ?? this.sentAt,
      metadata: metadata ?? this.metadata,
      actionData: actionData ?? this.actionData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        message,
        type,
        priority,
        isRead,
        isSent,
        scheduledAt,
        sentAt,
        metadata,
        actionData,
        createdAt,
        updatedAt,
      ];
}

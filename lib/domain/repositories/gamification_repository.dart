import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/domain/entities/notification.dart';

abstract class GamificationRepository {
  Future<List<Achievement>> getAchievements();
  Future<UserProgress> getUserProgress();
  Future<UserProgress> updateUserProgress(UserProgress progress);
  Future<UserProgress> addPoints(int points);
  Future<UserProgress> incrementAppointmentAttendance();
  Future<List<PregnancyMilestone>> getPregnancyMilestones();
  Future<List<Notification>> getNotifications();
  Future<List<Notification>> getUnreadNotifications();
  Future<Notification> markNotificationAsRead(int notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<List<Achievement>> checkAndAwardAchievements();
  Future<Map<String, dynamic>> getDashboardData();
} 
import 'package:ehealth_app/data/datasources/gamification_remote_data_source.dart';
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/domain/entities/notification.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDataSource remoteDataSource;

  GamificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Achievement>> getAchievements() async {
    try {
      final achievementModels = await remoteDataSource.getAchievements();
      return achievementModels;
    } catch (e) {
      throw Exception('Failed to get achievements: $e');
    }
  }

  @override
  Future<UserProgress> getUserProgress() async {
    try {
      final userProgressModel = await remoteDataSource.getUserProgress();
      return userProgressModel;
    } catch (e) {
      throw Exception('Failed to get user progress: $e');
    }
  }

  @override
  Future<UserProgress> updateUserProgress(UserProgress progress) async {
    try {
      final userProgressModel = await remoteDataSource.updateUserProgress(progress as dynamic);
      return userProgressModel;
    } catch (e) {
      throw Exception('Failed to update user progress: $e');
    }
  }

  @override
  Future<UserProgress> addPoints(int points) async {
    try {
      final userProgressModel = await remoteDataSource.addPoints(points);
      return userProgressModel;
    } catch (e) {
      throw Exception('Failed to add points: $e');
    }
  }

  @override
  Future<UserProgress> incrementAppointmentAttendance() async {
    try {
      final userProgressModel = await remoteDataSource.incrementAppointmentAttendance();
      return userProgressModel;
    } catch (e) {
      throw Exception('Failed to increment appointment attendance: $e');
    }
  }

  @override
  Future<List<PregnancyMilestone>> getPregnancyMilestones() async {
    try {
      final milestoneModels = await remoteDataSource.getPregnancyMilestones();
      return milestoneModels;
    } catch (e) {
      throw Exception('Failed to get pregnancy milestones: $e');
    }
  }

  @override
  Future<List<Notification>> getNotifications() async {
    try {
      final notificationModels = await remoteDataSource.getNotifications();
      return notificationModels;
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<List<Notification>> getUnreadNotifications() async {
    try {
      final notificationModels = await remoteDataSource.getUnreadNotifications();
      return notificationModels;
    } catch (e) {
      throw Exception('Failed to get unread notifications: $e');
    }
  }

  @override
  Future<Notification> markNotificationAsRead(int notificationId) async {
    try {
      final notificationModel = await remoteDataSource.markNotificationAsRead(notificationId);
      return notificationModel;
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await remoteDataSource.markAllNotificationsAsRead();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<List<Achievement>> checkAndAwardAchievements() async {
    try {
      final achievementModels = await remoteDataSource.checkAndAwardAchievements();
      return achievementModels;
    } catch (e) {
      throw Exception('Failed to check and award achievements: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      return await remoteDataSource.getDashboardData();
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }
} 
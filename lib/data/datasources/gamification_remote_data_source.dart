// lib/data/datasources/gamification_remote_data_source.dart
import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/data/models/achievement_model.dart';
import 'package:ehealth_app/data/models/user_progress_model.dart';
import 'package:ehealth_app/data/models/pregnancy_milestone_model.dart';
import 'package:ehealth_app/data/models/notification_model.dart';
import 'package:ehealth_app/core/config/api_config.dart';

abstract class GamificationRemoteDataSource {
  Future<List<AchievementModel>> getAchievements();
  Future<UserProgressModel> getUserProgress();
  Future<UserProgressModel> updateUserProgress(UserProgressModel progress);
  Future<UserProgressModel> addPoints(int points);
  Future<UserProgressModel> incrementAppointmentAttendance();
  Future<List<PregnancyMilestoneModel>> getPregnancyMilestones();
  Future<List<NotificationModel>> getNotifications();
  Future<List<NotificationModel>> getUnreadNotifications();
  Future<NotificationModel> markNotificationAsRead(int notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<List<AchievementModel>> checkAndAwardAchievements();
  Future<Map<String, dynamic>> getDashboardData();
}

class GamificationRemoteDataSourceImpl implements GamificationRemoteDataSource {
  final ApiClient apiClient;

  GamificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final response = await apiClient.get(ApiConfig.achievementsUrl);
    final List<dynamic> jsonList = response;
    return jsonList.map((json) => AchievementModel.fromJson(json)).toList();
  }

  @override
  Future<UserProgressModel> getUserProgress() async {
    final response = await apiClient.get(ApiConfig.userProgressUrl);
    return UserProgressModel.fromJson(response);
  }

  @override
  Future<UserProgressModel> updateUserProgress(
      UserProgressModel progress) async {
    final response = await apiClient.patch(
      ApiConfig.userProgressUrl,
      body: progress.toJson(),
    );
    return UserProgressModel.fromJson(response);
  }

  @override
  Future<UserProgressModel> addPoints(int points) async {
    final response = await apiClient.post(
      ApiConfig.userProgressAddPointsUrl,
      body: {'points': points},
    );
    return UserProgressModel.fromJson(response);
  }

  @override
  Future<UserProgressModel> incrementAppointmentAttendance() async {
    final response =
        await apiClient.post(ApiConfig.userProgressIncrementAppointmentUrl);
    return UserProgressModel.fromJson(response);
  }

  @override
  Future<List<PregnancyMilestoneModel>> getPregnancyMilestones() async {
    final response = await apiClient.get(ApiConfig.pregnancyMilestonesUrl);
    final List<dynamic> jsonList = response;
    return jsonList
        .map((json) => PregnancyMilestoneModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiClient.get(ApiConfig.notificationsUrl);
    final List<dynamic> jsonList = response;
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications() async {
    final response = await apiClient.get(ApiConfig.unreadNotificationsUrl);
    final List<dynamic> jsonList = response;
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<NotificationModel> markNotificationAsRead(int notificationId) async {
    final response =
        await apiClient.patch(ApiConfig.getNotificationReadUrl(notificationId));
    return NotificationModel.fromJson(response);
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    await apiClient.patch(ApiConfig.markAllNotificationsReadUrl);
  }

  @override
  Future<List<AchievementModel>> checkAndAwardAchievements() async {
    final response = await apiClient.post(ApiConfig.checkAchievementsUrl);
    final List<dynamic> jsonList = response;
    return jsonList.map((json) => AchievementModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    final response = await apiClient.get(ApiConfig.dashboardUrl);
    return response as Map<String, dynamic>;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  final http.Client client;

  GamificationRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.achievementsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AchievementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get achievements: ${response.body}');
    }
  }

  @override
  Future<UserProgressModel> getUserProgress() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.userProgressUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return UserProgressModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      // Si no existe progreso, crear uno vacío
      return UserProgressModel(
        id: 0,
        userId: 0,
        totalPoints: 0,
        level: 1,
        experiencePoints: 0,
        appointmentsAttended: 0,
        healthCheckupsCompleted: 0,
        educationModulesCompleted: 0,
        currentStreak: 0,
        longestStreak: 0,
        lastActivityDate: null,
        completedMilestones: const [],
        unlockedAchievements: const [],
        weeklyGoals: const {},
        monthlyGoals: const {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Failed to get user progress: ${response.body}');
    }
  }

  @override
  Future<UserProgressModel> updateUserProgress(
      UserProgressModel progress) async {
    final headers = await _getHeaders();

    final response = await client.patch(
      Uri.parse(ApiConfig.userProgressUrl),
      headers: headers,
      body: json.encode(progress.toJson()),
    );

    if (response.statusCode == 200) {
      return UserProgressModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user progress: ${response.body}');
    }
  }

  @override
  Future<UserProgressModel> addPoints(int points) async {
    final headers = await _getHeaders();

    final response = await client.post(
      Uri.parse(ApiConfig.userProgressAddPointsUrl),
      headers: headers,
      body: json.encode({'points': points}),
    );

    if (response.statusCode == 200) {
      return UserProgressModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add points: ${response.body}');
    }
  }

  @override
  Future<UserProgressModel> incrementAppointmentAttendance() async {
    final headers = await _getHeaders();

    final response = await client.post(
      Uri.parse(ApiConfig.userProgressIncrementAppointmentUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return UserProgressModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to increment appointment attendance: ${response.body}');
    }
  }

  @override
  Future<List<PregnancyMilestoneModel>> getPregnancyMilestones() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.pregnancyMilestonesUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => PregnancyMilestoneModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to get pregnancy milestones: ${response.body}');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.notificationsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get notifications: ${response.body}');
    }
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.unreadNotificationsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get unread notifications: ${response.body}');
    }
  }

  @override
  Future<NotificationModel> markNotificationAsRead(int notificationId) async {
    final headers = await _getHeaders();

    final response = await client.patch(
      Uri.parse(ApiConfig.getNotificationReadUrl(notificationId)),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return NotificationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    final headers = await _getHeaders();

    final response = await client.patch(
      Uri.parse(ApiConfig.markAllNotificationsReadUrl),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to mark all notifications as read: ${response.body}');
    }
  }

  @override
  Future<List<AchievementModel>> checkAndAwardAchievements() async {
    final headers = await _getHeaders();

    final response = await client.post(
      Uri.parse(ApiConfig.checkAchievementsUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AchievementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to check achievements: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardData() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse(ApiConfig.dashboardUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get dashboard data: ${response.body}');
    }
  }
}

import 'package:ehealth_app/domain/entities/user_progress.dart';

class UserProgressModel extends UserProgress {
  const UserProgressModel({
    required super.id,
    required super.userId,
    required super.totalPoints,
    required super.level,
    required super.experiencePoints,
    required super.appointmentsAttended,
    required super.healthCheckupsCompleted,
    required super.educationModulesCompleted,
    required super.currentStreak,
    required super.longestStreak,
    super.lastActivityDate,
    super.completedMilestones,
    super.unlockedAchievements,
    super.weeklyGoals,
    super.monthlyGoals,
    super.createdAt,
    super.updatedAt,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      id: json['id'],
      userId: json['userId'],
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      experiencePoints: json['experiencePoints'] ?? 0,
      appointmentsAttended: json['appointmentsAttended'] ?? 0,
      healthCheckupsCompleted: json['healthCheckupsCompleted'] ?? 0,
      educationModulesCompleted: json['educationModulesCompleted'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(json['lastActivityDate'])
          : null,
      completedMilestones: json['completedMilestones'] ?? [],
      unlockedAchievements: json['unlockedAchievements'] ?? [],
      weeklyGoals: json['weeklyGoals'] ?? {},
      monthlyGoals: json['monthlyGoals'] ?? {},
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

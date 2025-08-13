import 'package:equatable/equatable.dart';

class UserProgress extends Equatable {
  final int id;
  final int userId;
  final int totalPoints;
  final int level;
  final int experiencePoints;
  final int appointmentsAttended;
  final int healthCheckupsCompleted;
  final int educationModulesCompleted;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final List<dynamic>? completedMilestones;
  final List<dynamic>? unlockedAchievements;
  final Map<String, dynamic>? weeklyGoals;
  final Map<String, dynamic>? monthlyGoals;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProgress({
    required this.id,
    required this.userId,
    required this.totalPoints,
    required this.level,
    required this.experiencePoints,
    required this.appointmentsAttended,
    required this.healthCheckupsCompleted,
    required this.educationModulesCompleted,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    this.completedMilestones,
    this.unlockedAchievements,
    this.weeklyGoals,
    this.monthlyGoals,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalPoints': totalPoints,
      'level': level,
      'experiencePoints': experiencePoints,
      'appointmentsAttended': appointmentsAttended,
      'healthCheckupsCompleted': healthCheckupsCompleted,
      'educationModulesCompleted': educationModulesCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'completedMilestones': completedMilestones,
      'unlockedAchievements': unlockedAchievements,
      'weeklyGoals': weeklyGoals,
      'monthlyGoals': monthlyGoals,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Calcular puntos necesarios para el siguiente nivel
  int get pointsToNextLevel {
    return (level + 1) * 100 - experiencePoints;
  }

  // Verificar si el usuario tiene un streak activo
  bool get hasActiveStreak {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    final daysSinceLastActivity = now.difference(lastActivityDate!).inDays;
    return daysSinceLastActivity <= 1;
  }

  UserProgress copyWith({
    int? id,
    int? userId,
    int? totalPoints,
    int? level,
    int? experiencePoints,
    int? appointmentsAttended,
    int? healthCheckupsCompleted,
    int? educationModulesCompleted,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    List<dynamic>? completedMilestones,
    List<dynamic>? unlockedAchievements,
    Map<String, dynamic>? weeklyGoals,
    Map<String, dynamic>? monthlyGoals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      appointmentsAttended: appointmentsAttended ?? this.appointmentsAttended,
      healthCheckupsCompleted: healthCheckupsCompleted ?? this.healthCheckupsCompleted,
      educationModulesCompleted: educationModulesCompleted ?? this.educationModulesCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      weeklyGoals: weeklyGoals ?? this.weeklyGoals,
      monthlyGoals: monthlyGoals ?? this.monthlyGoals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    totalPoints,
    level,
    experiencePoints,
    appointmentsAttended,
    healthCheckupsCompleted,
    educationModulesCompleted,
    currentStreak,
    longestStreak,
    lastActivityDate,
    completedMilestones,
    unlockedAchievements,
    weeklyGoals,
    monthlyGoals,
    createdAt,
    updatedAt,
  ];
} 
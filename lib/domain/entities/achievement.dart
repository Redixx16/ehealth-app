import 'package:equatable/equatable.dart';

enum AchievementType {
  APPOINTMENT_ATTENDANCE,
  HEALTH_CHECKUP,
  EDUCATION_COMPLETION,
  MILESTONE_REACHED,
  STREAK_MAINTENANCE
}

enum AchievementDifficulty {
  BRONZE,
  SILVER,
  GOLD,
  PLATINUM
}

class Achievement extends Equatable {
  final int id;
  final String name;
  final String description;
  final AchievementType type;
  final AchievementDifficulty difficulty;
  final int pointsReward;
  final String iconName;
  final bool isActive;
  final Map<String, dynamic>? requirements;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.pointsReward,
    required this.iconName,
    required this.isActive,
    this.requirements,
    this.createdAt,
    this.updatedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: AchievementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AchievementType.APPOINTMENT_ATTENDANCE,
      ),
      difficulty: AchievementDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
        orElse: () => AchievementDifficulty.BRONZE,
      ),
      pointsReward: json['pointsReward'],
      iconName: json['iconName'],
      isActive: json['isActive'] ?? false,
      requirements: json['requirements'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'pointsReward': pointsReward,
      'iconName': iconName,
      'isActive': isActive,
      'requirements': requirements,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Achievement copyWith({
    int? id,
    String? name,
    String? description,
    AchievementType? type,
    AchievementDifficulty? difficulty,
    int? pointsReward,
    String? iconName,
    bool? isActive,
    Map<String, dynamic>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      pointsReward: pointsReward ?? this.pointsReward,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
      requirements: requirements ?? this.requirements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    difficulty,
    pointsReward,
    iconName,
    isActive,
    requirements,
    createdAt,
    updatedAt,
  ];
} 
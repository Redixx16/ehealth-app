import 'package:ehealth_app/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.difficulty,
    required super.pointsReward,
    required super.iconName,
    required super.isActive,
    super.requirements,
    super.createdAt,
    super.updatedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
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
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  @override
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
}

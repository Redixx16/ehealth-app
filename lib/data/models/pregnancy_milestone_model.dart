import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';

class PregnancyMilestoneModel extends PregnancyMilestone {
  const PregnancyMilestoneModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.weekNumber,
    required super.pointsReward,
    required super.iconName,
    super.tips,
    super.healthRecommendations,
    required super.isActive,
    super.requirements,
    super.createdAt,
    super.updatedAt,
  });

  factory PregnancyMilestoneModel.fromJson(Map<String, dynamic> json) {
    return PregnancyMilestoneModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: MilestoneType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MilestoneType.TRIMESTER_1,
      ),
      weekNumber: json['weekNumber'],
      pointsReward: json['pointsReward'],
      iconName: json['iconName'],
      tips: json['tips'],
      healthRecommendations: json['healthRecommendations'] ?? [],
      isActive: json['isActive'] ?? false,
      requirements: json['requirements'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

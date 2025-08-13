import 'package:equatable/equatable.dart';

enum MilestoneType {
  TRIMESTER_1,
  TRIMESTER_2,
  TRIMESTER_3,
  WEEKLY_CHECKUP,
  ULTRASOUND,
  LABOR_PREPARATION,
  BIRTH
}

class PregnancyMilestone extends Equatable {
  final int id;
  final String name;
  final String description;
  final MilestoneType type;
  final int weekNumber;
  final int pointsReward;
  final String iconName;
  final String? tips;
  final List<dynamic>? healthRecommendations;
  final bool isActive;
  final Map<String, dynamic>? requirements;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PregnancyMilestone({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.weekNumber,
    required this.pointsReward,
    required this.iconName,
    this.tips,
    this.healthRecommendations,
    required this.isActive,
    this.requirements,
    this.createdAt,
    this.updatedAt,
  });

  factory PregnancyMilestone.fromJson(Map<String, dynamic> json) {
    return PregnancyMilestone(
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
      'weekNumber': weekNumber,
      'pointsReward': pointsReward,
      'iconName': iconName,
      'tips': tips,
      'healthRecommendations': healthRecommendations,
      'isActive': isActive,
      'requirements': requirements,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  PregnancyMilestone copyWith({
    int? id,
    String? name,
    String? description,
    MilestoneType? type,
    int? weekNumber,
    int? pointsReward,
    String? iconName,
    String? tips,
    List<dynamic>? healthRecommendations,
    bool? isActive,
    Map<String, dynamic>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PregnancyMilestone(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      weekNumber: weekNumber ?? this.weekNumber,
      pointsReward: pointsReward ?? this.pointsReward,
      iconName: iconName ?? this.iconName,
      tips: tips ?? this.tips,
      healthRecommendations: healthRecommendations ?? this.healthRecommendations,
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
    weekNumber,
    pointsReward,
    iconName,
    tips,
    healthRecommendations,
    isActive,
    requirements,
    createdAt,
    updatedAt,
  ];
} 
part of 'gamification_bloc.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProgress extends GamificationEvent {
  final int userId;

  const LoadUserProgress({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadAchievements extends GamificationEvent {
  final int userId;

  const LoadAchievements({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadPregnancyMilestones extends GamificationEvent {
  final int patientId;

  const LoadPregnancyMilestones({required this.patientId});

  @override
  List<Object> get props => [patientId];
}

class MarkAppointmentAttended extends GamificationEvent {
  final int userId;
  final int appointmentId;

  const MarkAppointmentAttended({
    required this.userId,
    required this.appointmentId,
  });

  @override
  List<Object> get props => [userId, appointmentId];
}

class MarkMilestoneCompleted extends GamificationEvent {
  final int userId;
  final int milestoneId;
  final int pointsReward;

  const MarkMilestoneCompleted({
    required this.userId,
    required this.milestoneId,
    required this.pointsReward,
  });

  @override
  List<Object> get props => [userId, milestoneId, pointsReward];
}

class CheckIn extends GamificationEvent {
  final int userId;

  const CheckIn({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UnlockAchievement extends GamificationEvent {
  final int userId;
  final int achievementId;
  final int pointsReward;

  const UnlockAchievement({
    required this.userId,
    required this.achievementId,
    required this.pointsReward,
  });

  @override
  List<Object> get props => [userId, achievementId, pointsReward];
} 
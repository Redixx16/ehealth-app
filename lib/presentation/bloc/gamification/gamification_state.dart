part of 'gamification_bloc.dart';

abstract class GamificationState extends Equatable {
  const GamificationState();

  @override
  List<Object> get props => [];
}

class GamificationInitial extends GamificationState {}

class GamificationLoading extends GamificationState {}

class UserProgressLoaded extends GamificationState {
  final UserProgress progress;

  const UserProgressLoaded(this.progress);

  @override
  List<Object> get props => [progress];
}

class AchievementsLoaded extends GamificationState {
  final List<Achievement> achievements;

  const AchievementsLoaded(this.achievements);

  @override
  List<Object> get props => [achievements];
}

class PregnancyMilestonesLoaded extends GamificationState {
  final List<PregnancyMilestone> milestones;

  const PregnancyMilestonesLoaded(this.milestones);

  @override
  List<Object> get props => [milestones];
}

class GamificationSuccess extends GamificationState {
  final String message;

  const GamificationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class GamificationError extends GamificationState {
  final String message;

  const GamificationError(this.message);

  @override
  List<Object> get props => [message];
} 
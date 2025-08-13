// lib/domain/usecases/gamification/check_and_award_achievements.dart
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class CheckAndAwardAchievementsUseCase {
  final GamificationRepository repository;

  CheckAndAwardAchievementsUseCase(this.repository);

  Future<List<Achievement>> execute() {
    return repository.checkAndAwardAchievements();
  }
}

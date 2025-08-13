// lib/domain/usecases/gamification/get_achievements.dart
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class GetAchievementsUseCase {
  final GamificationRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<List<Achievement>> execute() {
    return repository.getAchievements();
  }
}

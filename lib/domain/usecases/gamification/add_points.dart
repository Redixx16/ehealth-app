import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class AddPointsUseCase {
  final GamificationRepository repository;

  AddPointsUseCase(this.repository);

  Future<UserProgress> execute(int points) {
    return repository.addPoints(points);
  }
}

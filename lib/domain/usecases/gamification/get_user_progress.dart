// lib/domain/usecases/gamification/get_user_progress.dart
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class GetUserProgressUseCase {
  final GamificationRepository repository;

  GetUserProgressUseCase(this.repository);

  Future<UserProgress> execute() {
    return repository.getUserProgress();
  }
}

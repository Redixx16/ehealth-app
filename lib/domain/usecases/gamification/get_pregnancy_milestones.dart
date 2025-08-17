import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class GetPregnancyMilestonesUseCase {
  final GamificationRepository repository;

  GetPregnancyMilestonesUseCase(this.repository);

  Future<List<PregnancyMilestone>> execute() {
    return repository.getPregnancyMilestones();
  }
}

import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';

class IncrementAppointmentAttendanceUseCase {
  final GamificationRepository repository;

  IncrementAppointmentAttendanceUseCase(this.repository);

  Future<UserProgress> execute() {
    return repository.incrementAppointmentAttendance();
  }
}

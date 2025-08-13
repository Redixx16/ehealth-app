// lib/domain/usecases/appointments/delete_appointment.dart
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';

class DeleteAppointmentUseCase {
  final AppointmentRepository repository;

  DeleteAppointmentUseCase(this.repository);

  Future<void> execute({required int id}) {
    return repository.deleteAppointment(id);
  }
}

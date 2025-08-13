// lib/domain/usecases/appointments/create_appointment.dart
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';

class CreateAppointmentUseCase {
  final AppointmentRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<void> execute(
      {required int patientId, required DateTime appointmentDate}) {
    return repository.createAppointment(patientId, appointmentDate);
  }
}

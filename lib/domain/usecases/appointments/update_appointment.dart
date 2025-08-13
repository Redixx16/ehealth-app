// lib/domain/usecases/appointments/update_appointment.dart
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase(this.repository);

  Future<void> execute({required int id, required UpdateAppointmentDto dto}) {
    return repository.updateAppointment(id, dto);
  }
}

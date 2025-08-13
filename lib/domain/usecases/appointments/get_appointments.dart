// lib/domain/usecases/appointments/get_appointments.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';

class GetAppointmentsUseCase {
  final AppointmentRepository repository;

  GetAppointmentsUseCase(this.repository);

  Future<List<Appointment>> execute() {
    return repository.getAppointments();
  }
}

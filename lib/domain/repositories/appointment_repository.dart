// lib/domain/repositories/appointment_repository.dart
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/domain/entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment> getAppointmentById(int id);
  Future<void> createAppointment(int patientId, DateTime appointmentDate);
  Future<void> updateAppointment(int id, UpdateAppointmentDto dto);
  Future<void> deleteAppointment(int id);
}

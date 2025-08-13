// lib/data/repositories/appointment_repository_impl.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createAppointment(int patientId, DateTime appointmentDate) {
    return remoteDataSource.createAppointment(patientId, appointmentDate);
  }

  @override
  Future<void> deleteAppointment(int id) {
    return remoteDataSource.deleteAppointment(id);
  }

  @override
  Future<Appointment> getAppointmentById(int id) {
    return remoteDataSource.getAppointmentById(id);
  }

  @override
  Future<List<Appointment>> getAppointments() {
    return remoteDataSource.getAppointments();
  }

  @override
  Future<void> updateAppointment(int id, UpdateAppointmentDto dto) {
    return remoteDataSource.updateAppointment(id, dto);
  }
}

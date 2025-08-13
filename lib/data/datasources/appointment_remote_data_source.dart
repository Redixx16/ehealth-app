// lib/data/datasources/appointment_remote_data_source.dart
import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/core/config/api_config.dart';

class AppointmentRemoteDataSource {
  final ApiClient _apiClient;
  AppointmentRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> createAppointment(
      int patientId, DateTime appointmentDate) async {
    // ================== CORRECCIÓN CLAVE AQUÍ ==================
    // Antes se pasaba el endpoint relativo. Ahora se pasa la URL completa.
    await _apiClient.post(
      ApiConfig.appointmentsUrl, // Usamos la URL completa
      body: {
        'patientId': patientId,
        'appointment_date': appointmentDate.toIso8601String(),
      },
    );
    // ==========================================================
  }

  Future<void> updateAppointment(int id, UpdateAppointmentDto dto) async {
    // Construimos la URL completa para el endpoint específico
    await _apiClient.patch(
      '${ApiConfig.appointmentsUrl}/$id',
      body: dto.toJson(),
    );
  }

  Future<void> deleteAppointment(int id) async {
    await _apiClient.delete('${ApiConfig.appointmentsUrl}/$id');
  }

  Future<Appointment> getAppointmentById(int id) async {
    final response = await _apiClient.get('${ApiConfig.appointmentsUrl}/$id');
    return Appointment.fromJson(response);
  }

  Future<List<Appointment>> getAppointments() async {
    // ================== CORRECCIÓN CLAVE AQUÍ ==================
    // Antes usaba ApiConfig.appointmentsEndpoint ('/appointments')
    // Ahora usa ApiConfig.appointmentsUrl ('http://.../appointments')
    final response = await _apiClient.get(ApiConfig.appointmentsUrl);
    // ==========================================================

    final List<dynamic> data = response;
    return data.map((json) => Appointment.fromJson(json)).toList();
  }
}

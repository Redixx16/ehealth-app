// lib/data/datasources/appointment_remote_data_source.dart
import 'dart:convert';
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/core/config/api_config.dart';

class AppointmentRemoteDataSource {

  Future<void> createAppointment(
      int patientId, DateTime appointmentDate) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) throw Exception('No se encontró token.');

    final response = await http.post(
      Uri.parse(ApiConfig.appointmentsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'patientId': patientId,
        'appointment_date': appointmentDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Fallo al crear la cita: ${response.body}');
    }
  }

  Future<void> updateAppointment(int id, UpdateAppointmentDto dto) async {
    final token =
        (await SharedPreferences.getInstance()).getString('jwt_token');
    if (token == null) throw Exception('No se encontró token.');

    final response = await http.patch(
      Uri.parse('${ApiConfig.appointmentsUrl}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Fallo al actualizar la cita: ${response.body}');
    }
  }

  Future<void> deleteAppointment(int id) async {
    final token =
        (await SharedPreferences.getInstance()).getString('jwt_token');
    if (token == null) throw Exception('No se encontró token.');

    final response = await http.delete(
      Uri.parse('${ApiConfig.appointmentsUrl}/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Fallo al eliminar la cita: ${response.body}');
    }
  }

  Future<Appointment> getAppointmentById(int id) async {
    final token =
        (await SharedPreferences.getInstance()).getString('jwt_token');
    if (token == null) {
      throw Exception('No se encontró token.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.appointmentsUrl}/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // La API devuelve un solo objeto JSON, no una lista
      return Appointment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al obtener el detalle de la cita.');
    }
  }

  Future<List<Appointment>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('No se encontró token de autenticación.');
    }

    final response = await http.get(
      Uri.parse(ApiConfig.appointmentsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- Enviamos el token aquí
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Fallo al obtener las citas.');
    }
  }
}

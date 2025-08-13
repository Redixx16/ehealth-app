// lib/domain/entities/appointment.dart
import 'package:ehealth_app/domain/entities/user.dart';

class Appointment {
  final int id;
  final DateTime appointmentDate;
  final String status;
  final String? recommendations;
  final User? patient; // <-- Añade al paciente

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.status,
    this.recommendations,
    this.patient, // <-- Añade al constructor
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      status: json['status'],
      recommendations: json['recommendations'],
      // Parsea el objeto anidado del paciente si existe
      patient: json['patient'] != null ? User.fromJson(json['patient']) : null,
    );
  }
}

// lib/domain/repositories/patient_repository.dart
import 'package:ehealth_app/domain/entities/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> getPatients(); // <-- AÑADE ESTA LÍNEA
  Future<Patient> createPatient(Patient patient);
  Future<Patient> getPatient();
  Future<Patient> updatePatient(Patient patient);
  Future<void> deletePatient();
}

// lib/data/datasources/patient_remote_data_source.dart
import 'package:ehealth_app/data/models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<PatientModel>> getPatients(); // <-- AÑADE ESTA LÍNEA
  Future<PatientModel> createPatient(PatientModel patient);
  Future<PatientModel> getPatient();
  Future<PatientModel> updatePatient(PatientModel patient);
  Future<void> deletePatient();
  // ================== NUEVO MÉTODO ==================
  Future<PatientModel> registerPatient(PatientModel patient, String email);
  // =================================================
}


import 'package:ehealth_app/domain/entities/patient.dart';

abstract class PatientRepository {
  Future<Patient> createPatient(Patient patient);
  Future<Patient> getPatient();
  Future<Patient> updatePatient(Patient patient);
  Future<void> deletePatient();
}


import 'package:ehealth_app/data/models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<PatientModel> createPatient(PatientModel patient);
  Future<PatientModel> getPatient();
  Future<PatientModel> updatePatient(PatientModel patient);
  Future<void> deletePatient();
}

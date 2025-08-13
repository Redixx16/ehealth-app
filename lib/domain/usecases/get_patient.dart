// lib/domain/usecases/get_patient.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';

class GetPatientUseCase {
  final PatientRepository repository;

  GetPatientUseCase(this.repository);

  Future<Patient> execute() {
    return repository.getPatient();
  }
}

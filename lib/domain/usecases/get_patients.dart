// lib/domain/usecases/get_patients.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';

class GetPatientsUseCase {
  final PatientRepository repository;

  GetPatientsUseCase(this.repository);

  Future<List<Patient>> execute() {
    return repository.getPatients();
  }
}

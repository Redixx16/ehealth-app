// lib/domain/usecases/register_patient.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';

class RegisterPatientUseCase {
  final PatientRepository repository;

  RegisterPatientUseCase(this.repository);

  Future<Patient> execute({
    required String fullName,
    required String email,
    required String nationalId,
    required DateTime dateOfBirth,
    required String address,
    required String phoneNumber,
    required DateTime lastMenstrualPeriod,
    required String medicalHistory,
  }) async {
    // Crear la entidad Patient temporal
    final patient = Patient(
      id: 0, // Se asignará en el backend
      userId: 0, // Se asignará en el backend
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      nationalId: nationalId,
      address: address,
      phoneNumber: phoneNumber,
      lastMenstrualPeriod: lastMenstrualPeriod,
      estimatedDueDate: lastMenstrualPeriod.add(const Duration(days: 280)),
      medicalHistory: medicalHistory,
    );

    return await repository.registerPatient(patient, email);
  }
}

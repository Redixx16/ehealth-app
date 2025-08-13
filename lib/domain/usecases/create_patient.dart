// lib/domain/usecases/create_patient.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';

class CreatePatientUseCase {
  final PatientRepository repository;

  CreatePatientUseCase(this.repository);

  Future<Patient> execute(Patient patient) {
    // Aquí es donde, en el futuro, podrías añadir más lógica, como:
    // - Enviar un email de bienvenida.
    // - Crear un registro de progreso inicial en gamificación.
    // Por ahora, simplemente llama al repositorio.
    return repository.createPatient(patient);
  }
}

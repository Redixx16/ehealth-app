import 'package:ehealth_app/data/datasources/patient_remote_data_source.dart';
import 'package:ehealth_app/data/models/patient_model.dart';
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Patient> createPatient(Patient patient) async {
    // Convertir Patient a PatientModel
    final patientModel = PatientModel(
      id: patient.id,
      userId: patient.userId, // <-- CORRECCIÓN: Se pasa el userId
      fullName: patient.fullName,
      dateOfBirth: patient.dateOfBirth,
      nationalId: patient.nationalId,
      address: patient.address,
      phoneNumber: patient.phoneNumber,
      lastMenstrualPeriod: patient.lastMenstrualPeriod,
      estimatedDueDate: patient.estimatedDueDate,
      medicalHistory: patient.medicalHistory,
    );

    final createdPatient = await remoteDataSource.createPatient(patientModel);
    return createdPatient;
  }

  @override
  Future<List<Patient>> getPatients() async {
    return await remoteDataSource.getPatients();
  }

  @override
  Future<Patient> getPatient() async {
    return await remoteDataSource.getPatient();
  }

  @override
  Future<Patient> updatePatient(Patient patient) async {
    // Convertir Patient a PatientModel
    final patientModel = PatientModel(
      id: patient.id,
      userId: patient.userId, // <-- CORRECCIÓN: Se pasa el userId
      fullName: patient.fullName,
      dateOfBirth: patient.dateOfBirth,
      nationalId: patient.nationalId,
      address: patient.address,
      phoneNumber: patient.phoneNumber,
      lastMenstrualPeriod: patient.lastMenstrualPeriod,
      estimatedDueDate: patient.estimatedDueDate,
      medicalHistory: patient.medicalHistory,
    );

    final updatedPatient = await remoteDataSource.updatePatient(patientModel);
    return updatedPatient;
  }

  @override
  Future<void> deletePatient() async {
    return await remoteDataSource.deletePatient();
  }
}

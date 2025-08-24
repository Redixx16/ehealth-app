part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class GetAllPatients extends PatientEvent {}

class GetPatient extends PatientEvent {}

class CreatePatient extends PatientEvent {
  final Patient patient;

  const CreatePatient(this.patient);

  @override
  List<Object> get props => [patient];
}

// ================== NUEVO EVENTO ==================
class RegisterPatient extends PatientEvent {
  final String fullName;
  final String email;
  final String nationalId;
  final DateTime dateOfBirth;
  final String address;
  final String phoneNumber;
  final DateTime lastMenstrualPeriod;
  final String medicalHistory;

  const RegisterPatient({
    required this.fullName,
    required this.email,
    required this.nationalId,
    required this.dateOfBirth,
    required this.address,
    required this.phoneNumber,
    required this.lastMenstrualPeriod,
    required this.medicalHistory,
  });

  @override
  List<Object> get props => [
        fullName,
        email,
        nationalId,
        dateOfBirth,
        address,
        phoneNumber,
        lastMenstrualPeriod,
        medicalHistory,
      ];
}
// =================================================

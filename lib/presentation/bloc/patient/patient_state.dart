part of 'patient_bloc.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientProfileNotFound extends PatientState {}

class PatientLoaded extends PatientState {
  final Patient patient;

  const PatientLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}

class AllPatientsLoaded extends PatientState {
  final List<Patient> patients;

  const AllPatientsLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object> get props => [message];
}

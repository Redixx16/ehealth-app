part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class CreatePatient extends PatientEvent {
  final Patient patient;

  const CreatePatient(this.patient);

  @override
  List<Object> get props => [patient];
}

class GetPatient extends PatientEvent {}

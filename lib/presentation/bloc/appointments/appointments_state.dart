import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:equatable/equatable.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();
  @override
  List<Object> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoadSuccess extends AppointmentsState {
  final List<Appointment> appointments;
  const AppointmentsLoadSuccess(this.appointments);
  @override
  List<Object> get props => [appointments];
}

class AppointmentsLoadFailure extends AppointmentsState {
  final String error;
  const AppointmentsLoadFailure(this.error);
  @override
  List<Object> get props => [error];
}

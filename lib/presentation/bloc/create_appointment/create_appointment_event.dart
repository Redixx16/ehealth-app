import 'package:equatable/equatable.dart';

abstract class CreateAppointmentEvent extends Equatable {
  const CreateAppointmentEvent();
  @override
  List<Object> get props => [];
}

class CreateButtonPressed extends CreateAppointmentEvent {
  final int patientId;
  final DateTime appointmentDate;

  const CreateButtonPressed(
      {required this.patientId, required this.appointmentDate});

  @override
  List<Object> get props => [patientId, appointmentDate];
}

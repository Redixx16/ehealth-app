import 'package:equatable/equatable.dart';

abstract class DeleteAppointmentEvent extends Equatable {
  const DeleteAppointmentEvent();
  @override
  List<Object> get props => [];
}

class DeleteButtonPressed extends DeleteAppointmentEvent {
  final int appointmentId;
  const DeleteButtonPressed({required this.appointmentId});
  @override
  List<Object> get props => [appointmentId];
}

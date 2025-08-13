// lib/presentation/bloc/update_appointment/update_appointment_event.dart
import 'package:equatable/equatable.dart';

abstract class UpdateAppointmentEvent extends Equatable {
  const UpdateAppointmentEvent();

  @override
  List<Object> get props => [];
}

// Evento que se dispara cuando el usuario presiona "Guardar Cambios"
class SaveChangesPressed extends UpdateAppointmentEvent {
  final int appointmentId;
  final String status;
  final String recommendations;

  const SaveChangesPressed({
    required this.appointmentId,
    required this.status,
    required this.recommendations,
  });

  @override
  List<Object> get props => [appointmentId, status, recommendations];
}

// lib/presentation/bloc/update_appointment/update_appointment_state.dart
import 'package:equatable/equatable.dart';

abstract class UpdateAppointmentState extends Equatable {
  const UpdateAppointmentState();

  @override
  List<Object> get props => [];
}

// Estado inicial, no ha pasado nada
class UpdateAppointmentInitial extends UpdateAppointmentState {}

// Estado de carga, se muestra el CircularProgressIndicator
class UpdateAppointmentLoading extends UpdateAppointmentState {}

// Estado de éxito, la cita se actualizó correctamente
class UpdateAppointmentSuccess extends UpdateAppointmentState {}

// Estado de fallo, ocurrió un error
class UpdateAppointmentFailure extends UpdateAppointmentState {
  final String error;

  const UpdateAppointmentFailure(this.error);

  @override
  List<Object> get props => [error];
}

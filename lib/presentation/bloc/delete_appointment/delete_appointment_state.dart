import 'package:equatable/equatable.dart';

abstract class DeleteAppointmentState extends Equatable {
  const DeleteAppointmentState();
  @override
  List<Object> get props => [];
}

class DeleteAppointmentInitial extends DeleteAppointmentState {}

class DeleteAppointmentLoading extends DeleteAppointmentState {}

class DeleteAppointmentSuccess extends DeleteAppointmentState {}

class DeleteAppointmentFailure extends DeleteAppointmentState {
  final String error;
  const DeleteAppointmentFailure(this.error);
  @override
  List<Object> get props => [error];
}

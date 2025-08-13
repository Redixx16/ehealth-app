import 'package:equatable/equatable.dart';

abstract class CreateAppointmentState extends Equatable {
  const CreateAppointmentState();
  @override
  List<Object> get props => [];
}

class CreateAppointmentInitial extends CreateAppointmentState {}

class CreateAppointmentLoading extends CreateAppointmentState {}

class CreateAppointmentSuccess extends CreateAppointmentState {}

class CreateAppointmentFailure extends CreateAppointmentState {
  final String error;
  const CreateAppointmentFailure(this.error);
  @override
  List<Object> get props => [error];
}

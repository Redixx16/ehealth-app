// lib/presentation/bloc/delete_appointment/delete_appointment_bloc.dart
import 'package:ehealth_app/domain/usecases/appointments/delete_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_appointment_event.dart';
import 'delete_appointment_state.dart';

class DeleteAppointmentBloc
    extends Bloc<DeleteAppointmentEvent, DeleteAppointmentState> {
  final DeleteAppointmentUseCase deleteAppointmentUseCase;

  DeleteAppointmentBloc({required this.deleteAppointmentUseCase})
      : super(DeleteAppointmentInitial()) {
    on<DeleteButtonPressed>((event, emit) async {
      emit(DeleteAppointmentLoading());
      try {
        await deleteAppointmentUseCase.execute(id: event.appointmentId);
        emit(DeleteAppointmentSuccess());
      } catch (e) {
        emit(DeleteAppointmentFailure(e.toString()));
      }
    });
  }
}

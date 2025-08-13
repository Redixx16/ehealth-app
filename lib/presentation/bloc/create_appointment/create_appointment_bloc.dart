// lib/presentation/bloc/create_appointment/create_appointment_bloc.dart
import 'package:ehealth_app/domain/usecases/appointments/create_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_appointment_event.dart';
import 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final CreateAppointmentUseCase createAppointmentUseCase;

  CreateAppointmentBloc({required this.createAppointmentUseCase})
      : super(CreateAppointmentInitial()) {
    on<CreateButtonPressed>((event, emit) async {
      emit(CreateAppointmentLoading());
      try {
        await createAppointmentUseCase.execute(
            patientId: event.patientId, appointmentDate: event.appointmentDate);
        emit(CreateAppointmentSuccess());
      } catch (e) {
        emit(CreateAppointmentFailure(e.toString()));
      }
    });
  }
}

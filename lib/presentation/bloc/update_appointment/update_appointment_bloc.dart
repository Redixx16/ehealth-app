// lib/presentation/bloc/update_appointment/update_appointment_bloc.dart
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:ehealth_app/domain/usecases/appointments/update_appointment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_appointment_event.dart';
import 'update_appointment_state.dart';

class UpdateAppointmentBloc
    extends Bloc<UpdateAppointmentEvent, UpdateAppointmentState> {
  final UpdateAppointmentUseCase updateAppointmentUseCase;

  UpdateAppointmentBloc({required this.updateAppointmentUseCase})
      : super(UpdateAppointmentInitial()) {
    on<SaveChangesPressed>((event, emit) async {
      emit(UpdateAppointmentLoading());
      try {
        final dto = UpdateAppointmentDto(
          status: event.status,
          recommendations: event.recommendations,
        );
        await updateAppointmentUseCase.execute(
            id: event.appointmentId, dto: dto);
        emit(UpdateAppointmentSuccess());
      } catch (e) {
        emit(UpdateAppointmentFailure(e.toString()));
      }
    });
  }
}

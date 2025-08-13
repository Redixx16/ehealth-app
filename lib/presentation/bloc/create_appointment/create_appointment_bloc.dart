// lib/presentation/bloc/create_appointment/create_appointment_bloc.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_appointment_event.dart';
import 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  // 1. Declara la dependencia que necesita
  final AppointmentRemoteDataSource appointmentDataSource;

  // 2. Recíbela en el constructor
  CreateAppointmentBloc({required this.appointmentDataSource})
      : super(CreateAppointmentInitial()) {
    on<CreateButtonPressed>((event, emit) async {
      emit(CreateAppointmentLoading());
      try {
        // 3. Usa la dependencia inyectada
        await appointmentDataSource.createAppointment(
            event.patientId, event.appointmentDate);
        emit(CreateAppointmentSuccess());
      } catch (e) {
        emit(CreateAppointmentFailure(e.toString()));
      }
    });
  }
}

import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_appointment_event.dart';
import 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final AppointmentRemoteDataSource appointmentDataSource =
      AppointmentRemoteDataSource();

  CreateAppointmentBloc() : super(CreateAppointmentInitial()) {
    on<CreateButtonPressed>((event, emit) async {
      emit(CreateAppointmentLoading());
      try {
        await appointmentDataSource.createAppointment(
            event.patientId, event.appointmentDate);
        emit(CreateAppointmentSuccess());
      } catch (e) {
        emit(CreateAppointmentFailure(e.toString()));
      }
    });
  }
}

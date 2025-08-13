// lib/presentation/bloc/appointments/appointments_bloc.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentRemoteDataSource appointmentDataSource =
      AppointmentRemoteDataSource();

  AppointmentsBloc() : super(AppointmentsInitial()) {
    on<FetchAppointments>((event, emit) async {
      emit(AppointmentsLoading());
      try {
        final appointments = await appointmentDataSource.getAppointments();
        
        print('APPOINTMENTS_BLOC: Obtenidas ${appointments.length} citas.');
        
        emit(AppointmentsLoadSuccess(appointments));
      } catch (e) {
        print('APPOINTMENTS_BLOC: Error al obtener citas: $e');
        emit(AppointmentsLoadFailure(e.toString()));
      }
    });
  }
}

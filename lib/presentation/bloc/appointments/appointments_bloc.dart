// lib/presentation/bloc/appointments/appointments_bloc.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  // 1. Declara la dependencia final
  final AppointmentRemoteDataSource appointmentDataSource;

  // 2. Recibe la dependencia en el constructor
  AppointmentsBloc({required this.appointmentDataSource})
      : super(AppointmentsInitial()) {
    on<FetchAppointments>((event, emit) async {
      emit(AppointmentsLoading());
      try {
        // 3. Usa la dependencia inyectada
        final appointments = await appointmentDataSource.getAppointments();

        // Eliminamos el print para seguir buenas prácticas
        // print('APPOINTMENTS_BLOC: Obtenidas ${appointments.length} citas.');

        emit(AppointmentsLoadSuccess(appointments));
      } catch (e) {
        // print('APPOINTMENTS_BLOC: Error al obtener citas: $e');
        emit(AppointmentsLoadFailure(e.toString()));
      }
    });
  }
}

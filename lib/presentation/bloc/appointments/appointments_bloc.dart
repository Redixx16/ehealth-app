// lib/presentation/bloc/appointments/appointments_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehealth_app/domain/usecases/appointments/get_appointments.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;

  AppointmentsBloc({required this.getAppointmentsUseCase})
      : super(AppointmentsInitial()) {
    on<FetchAppointments>((event, emit) async {
      emit(AppointmentsLoading());
      try {
        final appointments = await getAppointmentsUseCase.execute();
        emit(AppointmentsLoadSuccess(appointments));
      } catch (e) {
        emit(AppointmentsLoadFailure(e.toString()));
      }
    });
  }
}

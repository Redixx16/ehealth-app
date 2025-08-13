// lib/presentation/bloc/delete_appointment/delete_appointment_bloc.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_appointment_event.dart';
import 'delete_appointment_state.dart';

class DeleteAppointmentBloc
    extends Bloc<DeleteAppointmentEvent, DeleteAppointmentState> {
  final AppointmentRemoteDataSource _dataSource;

  DeleteAppointmentBloc({required AppointmentRemoteDataSource dataSource})
      : _dataSource = dataSource,
        super(DeleteAppointmentInitial()) {
    on<DeleteButtonPressed>((event, emit) async {
      emit(DeleteAppointmentLoading());
      try {
        await _dataSource.deleteAppointment(event.appointmentId);
        emit(DeleteAppointmentSuccess());
      } catch (e) {
        emit(DeleteAppointmentFailure(e.toString()));
      }
    });
  }
}

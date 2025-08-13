// lib/presentation/bloc/update_appointment/update_appointment_bloc.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:ehealth_app/data/models/update_appointment_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'update_appointment_event.dart';
import 'update_appointment_state.dart';

class UpdateAppointmentBloc
    extends Bloc<UpdateAppointmentEvent, UpdateAppointmentState> {
  final AppointmentRemoteDataSource _dataSource;

  UpdateAppointmentBloc({required AppointmentRemoteDataSource dataSource})
      : _dataSource = dataSource,
        super(UpdateAppointmentInitial()) {
    on<SaveChangesPressed>((event, emit) async {
      emit(UpdateAppointmentLoading());
      try {
        final dto = UpdateAppointmentDto(
          status: event.status,
          recommendations: event.recommendations,
        );
        await _dataSource.updateAppointment(event.appointmentId, dto);
        emit(UpdateAppointmentSuccess());
      } catch (e) {
        emit(UpdateAppointmentFailure(e.toString()));
      }
    });
  }
}

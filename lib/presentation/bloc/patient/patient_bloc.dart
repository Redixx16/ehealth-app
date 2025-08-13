
import 'package:bloc/bloc.dart';
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/repositories/patient_repository.dart';
import 'package:equatable/equatable.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepository;

  PatientBloc({required this.patientRepository}) : super(PatientInitial()) {
    on<CreatePatient>((event, emit) async {
      emit(PatientLoading());
      try {
        final patient = await patientRepository.createPatient(event.patient);
        emit(PatientLoaded(patient));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<GetPatient>((event, emit) async {
      emit(PatientLoading());
      try {
        final patient = await patientRepository.getPatient();
        emit(PatientLoaded(patient));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });
  }
}

// lib/presentation/bloc/patient/patient_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:ehealth_app/core/error/exceptions.dart';
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/domain/usecases/create_patient.dart'; // <-- NUEVO
import 'package:ehealth_app/domain/usecases/get_patient.dart';
import 'package:ehealth_app/domain/usecases/get_patients.dart';
// ================== NUEVO IMPORT ==================
import 'package:ehealth_app/domain/usecases/register_patient.dart';
// =================================================
import 'package:equatable/equatable.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  // Ahora el BLoC depende completamente de Casos de Uso
  final GetPatientUseCase getPatientUseCase;
  final CreatePatientUseCase createPatientUseCase;
  final GetPatientsUseCase getPatientsUseCase; // <-- AÑADE LA DEPENDENCIA
  // ================== NUEVA DEPENDENCIA ==================
  final RegisterPatientUseCase registerPatientUseCase;
  // =================================================

  PatientBloc({
    required this.getPatientUseCase,
    required this.createPatientUseCase, // <-- NUEVO
    required this.getPatientsUseCase,
    // ================== NUEVO PARÁMETRO ==================
    required this.registerPatientUseCase,
    // =================================================
  }) : super(PatientInitial()) {
    on<GetAllPatients>((event, emit) async {
      emit(PatientLoading());
      try {
        final patients = await getPatientsUseCase.execute();
        emit(AllPatientsLoaded(patients));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<CreatePatient>((event, emit) async {
      emit(PatientLoading());
      try {
        // Usamos el nuevo Caso de Uso
        final patient = await createPatientUseCase.execute(event.patient);
        emit(PatientLoaded(patient));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    on<GetPatient>((event, emit) async {
      emit(PatientLoading());
      try {
        final patient = await getPatientUseCase.execute();
        emit(PatientLoaded(patient));
      } on PatientNotFoundException {
        emit(PatientProfileNotFound());
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });

    // ================== NUEVO MANEJADOR ==================
    on<RegisterPatient>((event, emit) async {
      emit(PatientLoading());
      try {
        final patient = await registerPatientUseCase.execute(
          fullName: event.fullName,
          email: event.email,
          nationalId: event.nationalId,
          dateOfBirth: event.dateOfBirth,
          address: event.address,
          phoneNumber: event.phoneNumber,
          lastMenstrualPeriod: event.lastMenstrualPeriod,
          medicalHistory: event.medicalHistory,
        );
        emit(PatientLoaded(patient));
      } catch (e) {
        emit(PatientError(e.toString()));
      }
    });
    // =================================================
  }
}

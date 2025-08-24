import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/data/models/patient_model.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'package:ehealth_app/core/error/exceptions.dart';
import 'patient_remote_data_source.dart';

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient apiClient;

  PatientRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PatientModel>> getPatients() async {
    final response = await apiClient.get(ApiConfig.allPatientsUrl);
    final List<dynamic> jsonList = response;
    return jsonList.map((json) => PatientModel.fromJson(json)).toList();
  }

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    // Aquí corregimos la URL que estaba causando el error.
    final response = await apiClient.post(
      ApiConfig.createPatientProfileUrl,
      body: patient.toJsonForCreation(),
    );
    return PatientModel.fromJson(response);
  }

  @override
  Future<PatientModel> getPatient() async {
    try {
      final response = await apiClient.get(ApiConfig.patientMeUrl);
      return PatientModel.fromJson(response);
    } on NotFoundException {
      throw PatientNotFoundException();
    }
  }

  @override
  Future<PatientModel> updatePatient(PatientModel patient) async {
    final response = await apiClient.patch(
      ApiConfig.patientMeUrl,
      body: patient.toJson(),
    );
    return PatientModel.fromJson(response);
  }

  @override
  Future<void> deletePatient() async {
    await apiClient.delete(ApiConfig.patientMeUrl);
  }

  @override
  Future<PatientModel> registerPatient(
      PatientModel patient, String email) async {
    final response = await apiClient.post(
      ApiConfig.registerPatientUrl,
      body: patient.toJsonForRegistration(email: email),
    );
    // La respuesta del backend al registrar una paciente es un User, no un Patient.
    // Creamos un PatientModel temporal para la confirmación.
    return PatientModel.fromJson(response);
  }
}

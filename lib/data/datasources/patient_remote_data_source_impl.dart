// lib/data/datasources/patient_remote_data_source_impl.dart
import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/data/models/patient_model.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'package:ehealth_app/core/error/exceptions.dart';
import 'patient_remote_data_source.dart';

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  // Reemplazamos http.Client por nuestro ApiClient centralizado
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
    final response = await apiClient.post(
      ApiConfig.patientsEndpoint, // Usamos el endpoint relativo
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
      // Si el ApiClient nos dice que no se encontró, lo relanzamos como una excepción
      // que el BLoC pueda entender.
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
}

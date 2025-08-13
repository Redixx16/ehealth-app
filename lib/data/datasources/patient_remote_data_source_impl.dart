// lib/data/datasources/patient_remote_data_source_impl.dart
import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/data/models/patient_model.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'patient_remote_data_source.dart';

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient apiClient;

  PatientRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    final response = await apiClient.post(
      ApiConfig.patientsEndpoint,
      body: patient.toJsonForCreation(),
    );
    return PatientModel.fromJson(response);
  }

  @override
  Future<PatientModel> getPatient() async {
    final response = await apiClient.get(ApiConfig.patientMeUrl);
    return PatientModel.fromJson(response);
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

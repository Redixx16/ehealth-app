
import 'dart:convert';
import 'package:ehealth_app/data/models/patient_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'patient_remote_data_source.dart';

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final http.Client client;

  PatientRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<PatientModel> createPatient(PatientModel patient) async {
    final headers = await _getHeaders();
    
    final response = await client.post(
      Uri.parse(ApiConfig.getPatientsUrl('')),
      headers: headers,
      body: json.encode(patient.toJsonForCreation()),
    );

    if (response.statusCode == 201) {
      return PatientModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create patient: ${response.body}');
    }
  }

  @override
  Future<PatientModel> getPatient() async {
    final headers = await _getHeaders();
    
    final response = await client.get(
      Uri.parse(ApiConfig.patientMeUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return PatientModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Patient not found');
    } else {
      throw Exception('Failed to get patient: ${response.body}');
    }
  }

  @override
  Future<PatientModel> updatePatient(PatientModel patient) async {
    final headers = await _getHeaders();
    
    final response = await client.patch(
      Uri.parse(ApiConfig.patientMeUrl),
      headers: headers,
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      return PatientModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update patient: ${response.body}');
    }
  }

  @override
  Future<void> deletePatient() async {
    final headers = await _getHeaders();
    
    final response = await client.delete(
      Uri.parse(ApiConfig.patientMeUrl),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient: ${response.body}');
    }
  }
}

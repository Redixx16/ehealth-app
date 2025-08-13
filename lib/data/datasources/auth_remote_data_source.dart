// lib/data/datasources/auth_remote_data_source.dart
import 'package:ehealth_app/core/api/api_client.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'package:ehealth_app/core/error/exceptions.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<String> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.authEndpoint + '/login',
        body: {'email': email, 'password': password},
      );
      return response['access_token'];
    } on BadRequestException catch (e) {
      // Re-lanza la excepción con un mensaje más amigable
      throw Exception(e.message);
    } catch (e) {
      // Para otros tipos de excepciones, relanza un mensaje genérico o el original
      throw Exception('Error al iniciar sesión. Inténtalo de nuevo.');
    }
  }

  Future<void> register(
      String email, String password, String role, String fullName) async {
    try {
      await _apiClient.post(
        ApiConfig.authEndpoint + '/register',
        body: {
          'email': email,
          'password': password,
          'role': role,
          'full_name': fullName,
        },
      );
    } on BadRequestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Error al registrar. Inténtalo de nuevo.');
    }
  }
}

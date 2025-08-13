// lib/data/datasources/auth_remote_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ehealth_app/core/config/api_config.dart';

class AuthRemoteDataSource {
  Future<String> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.loginUrl),
            headers: ApiConfig.defaultHeaders,
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else if (response.statusCode == 401) {
        throw Exception(
            'Credenciales incorrectas. Verifica tu email y contraseña.');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado. Verifica tu email.');
      } else if (response.statusCode >= 500) {
        throw Exception('Error del servidor. Intenta más tarde.');
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] ?? 'Error al iniciar sesión';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('Error al iniciar sesión: ${response.body}');
        }
      }
    } on http.ClientException catch (_) {
      throw Exception(
          'Error de conexión con el servidor. Verifica la IP y la conexión a la red.');
    } on SocketException catch (_) {
      throw Exception(
          'Error de conexión con el servidor. Verifica la IP y la conexión a la red.');
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout') ||
          e.toString().contains('timed out')) {
        throw Exception(
            'Tiempo de espera agotado. Verifica tu conexión a internet.');
      }
      if (e.toString().contains('Credenciales incorrectas') ||
          e.toString().contains('Usuario no encontrado') ||
          e.toString().contains('Error del servidor') ||
          e.toString().contains('Error de conexión') ||
          e.toString().contains('Tiempo de espera')) {
        rethrow;
      } else {
        throw Exception('Error inesperado: ${e.toString()}');
      }
    }
  }

  Future<void> register(String email, String password, String role, String fullName) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/register'),
            headers: ApiConfig.defaultHeaders,
            body: json.encode({
              'email': email,
              'password': password,
              'role': role,
              'full_name': fullName,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] ?? 'Error al registrar usuario';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('Error al registrar usuario: ${response.body}');
        }
      }
    } on http.ClientException catch (_) {
      throw Exception(
          'Error de conexión con el servidor. Verifica la IP y la conexión a la red.');
    } on SocketException catch (_) {
      throw Exception(
          'Error de conexión con el servidor. Verifica la IP y la conexión a la red.');
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout') ||
          e.toString().contains('timed out')) {
        throw Exception(
            'Tiempo de espera agotado. Verifica tu conexión a internet.');
      }
      if (e.toString().contains('Error de conexión') ||
          e.toString().contains('Tiempo de espera')) {
        rethrow;
      } else {
        throw Exception('Error inesperado: ${e.toString()}');
      }
    }
  }
}

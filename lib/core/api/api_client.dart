// lib/core/api/api_client.dart
import 'dart:convert';
import 'dart:async'; // Importado para TimeoutException
import 'dart:io';
import 'package:http/http.dart' as http; // <-- CORRECCIÓN AQUÍ
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/core/config/api_config.dart';
import 'package:ehealth_app/core/error/exceptions.dart';

class ApiClient {
  final http.Client client;
  ApiClient({required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse(endpoint);
    try {
      final response = await client
          .get(uri, headers: await _getHeaders())
          .timeout(ApiConfig.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } on FormatException {
      throw ServerException(message: 'Respuesta inválida del servidor.');
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    final uri = Uri.parse(endpoint);
    try {
      final response = await client
          .post(
            uri,
            headers: await _getHeaders(),
            body: json.encode(body),
          )
          .timeout(ApiConfig.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } on FormatException {
      throw ServerException(message: 'Respuesta inválida del servidor.');
    }
  }

  Future<dynamic> patch(String endpoint, {dynamic body}) async {
    final uri = Uri.parse(endpoint);
    try {
      final response = await client
          .patch(
            uri,
            headers: await _getHeaders(),
            body: json.encode(body),
          )
          .timeout(ApiConfig.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } on FormatException {
      throw ServerException(message: 'Respuesta inválida del servidor.');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse(endpoint);
    try {
      final response = await client
          .delete(uri, headers: await _getHeaders())
          .timeout(ApiConfig.connectionTimeout);
      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } on FormatException {
      throw ServerException(message: 'Respuesta inválida del servidor.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    // Si la respuesta no tiene cuerpo (ej. en un DELETE exitoso), no intentes decodificar.
    if (response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null; // O un `{'success': true}` si lo prefieres
      }
    }

    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonResponse;
      case 400:
        throw BadRequestException(
            message: jsonResponse['message'] ?? 'Petición incorrecta.');
      case 401:
      case 403:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 500:
      default:
        throw ServerException();
    }
  }
}

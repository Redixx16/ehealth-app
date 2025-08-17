// lib/core/api/api_client.dart
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
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

  Future<dynamic> get(String url) async {
    final uri = Uri.parse(url);
    try {
      print("    🔷 API_CLIENT: Intentando GET a $url");
      final response = await client
          .get(uri, headers: await _getHeaders())
          .timeout(ApiConfig.connectionTimeout);
      print(
          "    🔷 API_CLIENT: Respuesta recibida de $url con código ${response.statusCode}");
      return _handleResponse(response);
    } on SocketException {
      print("    ❌ API_CLIENT: Error de SocketException en $url");
      throw NetworkException();
    } on http.ClientException {
      print("    ❌ API_CLIENT: Error de ClientException en $url");
      throw NetworkException();
    } on TimeoutException {
      print("    ❌ API_CLIENT: Error de TimeoutException en $url");
      throw TimeoutException();
    } on FormatException {
      print(
          "    ❌ API_CLIENT: Error de FormatException (respuesta inválida) en $url");
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
            body: body != null ? json.encode(body) : null,
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
            body: body != null ? json.encode(body) : null,
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
    if (response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null;
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

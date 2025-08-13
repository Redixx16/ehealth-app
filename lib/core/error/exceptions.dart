// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Error inesperado del servidor.'});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(
      {this.message = 'No autorizado. Vuelve a iniciar sesión.'});
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException({this.message = 'Recurso no encontrado.'});
}

class PatientNotFoundException implements Exception {
  final String message;
  PatientNotFoundException({this.message = 'Perfil de paciente no encontrado.'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException(
      {this.message = 'Error de conexión. Revisa tu conexión a internet.'});
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(
      {this.message =
          'Tiempo de espera agotado. El servidor tardó mucho en responder.'});
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException({required this.message});
}

import 'package:ehealth_app/domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.dateOfBirth,
    required super.nationalId,
    required super.address,
    required super.phoneNumber,
    required super.lastMenstrualPeriod,
    required super.estimatedDueDate,
    required super.medicalHistory,
    super.createdAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    // ================== CORRECCIÓN CLAVE AQUÍ ==================
    // Verificamos si el objeto 'user' existe y tiene datos.
    // Si no existe, proporcionamos valores por defecto para evitar el error.
    final userJson = json['user'] as Map<String, dynamic>? ?? {};

    return PatientModel(
      id: json['id'],
      userId: userJson['id'] ?? 0, // Si no hay ID de usuario, se asigna 0
      fullName: userJson['full_name'] ??
          'Paciente sin nombre', // Si no hay nombre, se asigna un placeholder
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationalId: json['nationalId'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      lastMenstrualPeriod: DateTime.parse(json['lastMenstrualPeriod']),
      estimatedDueDate: DateTime.parse(json['estimatedDueDate']),
      medicalHistory: json['medicalHistory'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
    // ==========================================================
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationalId': nationalId,
      'address': address,
      'phoneNumber': phoneNumber,
      'lastMenstrualPeriod': lastMenstrualPeriod.toIso8601String(),
      'estimatedDueDate': estimatedDueDate.toIso8601String(),
      'medicalHistory': medicalHistory,
    };
  }

  Map<String, dynamic> toJsonForCreation() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationalId': nationalId,
      'address': address,
      'phoneNumber': phoneNumber,
      'lastMenstrualPeriod': lastMenstrualPeriod.toIso8601String(),
      'estimatedDueDate': estimatedDueDate.toIso8601String(),
      'medicalHistory': medicalHistory,
    };
  }

  // ================== NUEVO MÉTODO ==================
  Map<String, dynamic> toJsonForRegistration({required String email}) {
    return {
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationalId': nationalId,
      'address': address,
      'phoneNumber': phoneNumber,
      'lastMenstrualPeriod': lastMenstrualPeriod.toIso8601String(),
      'medicalHistory': medicalHistory,
    };
  }
  // =================================================
}

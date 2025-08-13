import 'package:ehealth_app/domain/entities/patient.dart';

class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.fullName,
    required super.dateOfBirth,
    required super.nationalId,
    required super.address,
    required super.phoneNumber,
    required super.lastMenstrualPeriod,
    required super.estimatedDueDate,
    required super.medicalHistory,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationalId: json['nationalId'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      lastMenstrualPeriod: DateTime.parse(json['lastMenstrualPeriod']),
      estimatedDueDate: DateTime.parse(json['estimatedDueDate']),
      medicalHistory: json['medicalHistory'],
    );
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

  // Método específico para crear pacientes (sin ID)
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
}

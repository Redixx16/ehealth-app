import 'package:equatable/equatable.dart';

enum RiskLevel { bajo, medio, alto }

class Patient extends Equatable {
  final int id; // ID del perfil de la paciente
  final int userId; // ID del usuario asociado
  final String fullName;
  final DateTime dateOfBirth;
  final String nationalId;
  final String address;
  final String phoneNumber;
  final DateTime lastMenstrualPeriod;
  final DateTime estimatedDueDate;
  final String medicalHistory;
  final DateTime? createdAt;

  const Patient({
    required this.id,
    required this.userId, // Añadido
    required this.fullName,
    required this.dateOfBirth,
    required this.nationalId,
    required this.address,
    required this.phoneNumber,
    required this.lastMenstrualPeriod,
    required this.estimatedDueDate,
    required this.medicalHistory,
    this.createdAt,
  });

  RiskLevel get riskLevel {
    final history = medicalHistory.toLowerCase();
    if (history.contains('preeclampsia') ||
        history.contains('diabetes') ||
        history.contains('hipertensión')) {
      return RiskLevel.alto;
    }
    if (history.contains('anemia') || history.contains('previo')) {
      return RiskLevel.medio;
    }
    return RiskLevel.bajo;
  }

  @override
  List<Object?> get props => [
        id,
        userId, // Añadido
        fullName,
        dateOfBirth,
        nationalId,
        address,
        phoneNumber,
        lastMenstrualPeriod,
        estimatedDueDate,
        medicalHistory,
        createdAt,
      ];
}

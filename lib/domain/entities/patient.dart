
import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final int id;
  final String fullName;
  final DateTime dateOfBirth;
  final String nationalId;
  final String address;
  final String phoneNumber;
  final DateTime lastMenstrualPeriod;
  final DateTime estimatedDueDate;
  final String medicalHistory;

  const Patient({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.nationalId,
    required this.address,
    required this.phoneNumber,
    required this.lastMenstrualPeriod,
    required this.estimatedDueDate,
    required this.medicalHistory,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        dateOfBirth,
        nationalId,
        address,
        phoneNumber,
        lastMenstrualPeriod,
        estimatedDueDate,
        medicalHistory,
      ];
}

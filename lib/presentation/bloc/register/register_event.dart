part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String role;
  final String fullName;

  RegisterSubmitted({required this.email, required this.password, required this.role, required this.fullName});
} 
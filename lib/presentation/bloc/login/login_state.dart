// lib/presentation/bloc/login/login_state.dart
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String role;
  final String fullName; // <-- AÑADIDO
  final String email; // <-- AÑADIDO

  const LoginSuccess({
    required this.role,
    required this.fullName, // <-- AÑADIDO
    required this.email, // <-- AÑADIDO
  });

  @override
  List<Object> get props => [role, fullName, email];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

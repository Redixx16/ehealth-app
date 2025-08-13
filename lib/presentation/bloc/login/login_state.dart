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
  final String role; // <-- AÑADE ESTA PROPIEDAD

  const LoginSuccess({required this.role}); // <-- ACTUALIZA EL CONSTRUCTOR

  @override
  List<Object> get props => [role];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

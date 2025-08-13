// lib/presentation/bloc/register/register_bloc.dart
import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // <-- CORRECCIÓN AQUÍ

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDataSource authRemoteDataSource;

  RegisterBloc({required this.authRemoteDataSource})
      : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        await authRemoteDataSource.register(
            event.email, event.password, event.role, event.fullName);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}

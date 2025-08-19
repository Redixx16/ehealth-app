import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource authRemoteDataSource;

  LoginBloc({required this.authRemoteDataSource}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final token =
            await authRemoteDataSource.login(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        final String role = decodedToken['role'] ?? 'rol_desconocido';
        final String fullName = decodedToken['full_name'] ?? 'Usuario';
        final String email = decodedToken['email'] ?? 'Sin correo';
        final int userId =
            decodedToken['sub']; // 'sub' es el estándar para el ID de usuario

        // Guardamos el ID del usuario para usarlo después
        await prefs.setInt('user_id', userId);

        emit(LoginSuccess(
          role: role,
          fullName: fullName,
          email: email,
        ));
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}

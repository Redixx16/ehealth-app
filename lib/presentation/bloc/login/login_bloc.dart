import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // 1. Declara la dependencia que el BLoC necesita.
  final AuthRemoteDataSource authRemoteDataSource;

  // 2. Recibe la dependencia a través del constructor.
  //    Ya no la creamos aquí dentro.
  LoginBloc({required this.authRemoteDataSource}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        // 3. Usa la dependencia que fue "inyectada" desde afuera.
        final token =
            await authRemoteDataSource.login(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final String role = decodedToken['role'];

        emit(LoginSuccess(role: role));
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}

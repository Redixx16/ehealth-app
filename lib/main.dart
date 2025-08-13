import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ehealth_app/core/config/environment_config.dart';
import 'injection_container.dart' as di;

// --- Paleta de Colores Profesional ---
const Color kPrimaryColorProfessional = Color(0xFF0D47A1);
const Color kBackgroundColorProfessional = Color(0xFFF5F7FA);

// --- FUNCIÓN PRINCIPAL ASÍNCRONA ---
Future<void> main() async {
  // Asegura que los bindings de Flutter estén listos antes de ejecutar código nativo.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el locale español para el formateo de fechas
  await initializeDateFormatting('es_ES', null);

  // Inicializa nuestro contenedor de dependencias antes de correr la app.
  await di.setupLocator();

  // Muestra información de configuración en desarrollo
  if (EnvironmentConfig.enableLogging) {
    print('🚀 Iniciando EHealth App...');
    print(EnvironmentConfig.environmentInfo);
  }

  // Ejecuta la aplicación.
  runApp(const MyApp());
}

// --- WIDGET RAÍZ DE LA APLICACIÓN ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<LoginBloc>()),
        BlocProvider(create: (context) => di.locator<PatientBloc>()),
        BlocProvider(create: (context) => di.locator<GamificationBloc>()),
      ],
      child: MaterialApp(
        title: 'E-Health App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColorProfessional,
          scaffoldBackgroundColor: kBackgroundColorProfessional,
          fontFamily: 'sans-serif',
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                  color: kPrimaryColorProfessional, width: 2.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

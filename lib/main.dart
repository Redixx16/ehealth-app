// lib/main.dart
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
// --- 1. IMPORTA EL BLOC DE NOTIFICACIONES ---
import 'package:ehealth_app/presentation/bloc/notifications/notification_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ehealth_app/core/config/environment_config.dart';
import 'injection_container.dart' as di;

// --- (El resto del código de la paleta de colores y tema no cambia) ---
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

final appTheme = ThemeData(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  fontFamily: GoogleFonts.poppins().fontFamily,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: kPrimaryColor,
    secondary: kPrimaryLightColor,
    surface: kBackgroundColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundColor,
    elevation: 0,
    iconTheme: const IconThemeData(color: kTextColor),
    titleTextStyle: GoogleFonts.poppins(
      color: kTextColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.poppins(color: kTextColor.withOpacity(0.7)),
    hintStyle: GoogleFonts.poppins(color: kTextColor.withOpacity(0.6)),
    prefixIconColor: kPrimaryColor.withOpacity(0.8),
    filled: true,
    fillColor: Colors.white.withOpacity(0.8),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: kPrimaryColor,
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
  ),
);

// --- (La función main no cambia) ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await di.setupLocator();

  if (EnvironmentConfig.enableLogging) {
    print('🚀 Iniciando EHealth App...');
    print(EnvironmentConfig.environmentInfo);
  }

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
        // --- 2. AÑADE EL PROVIDER PARA NOTIFICATIONBLOC AQUÍ ---
        BlocProvider(create: (context) => di.locator<NotificationBloc>()),
      ],
      child: MaterialApp(
        title: 'eHealth Prenatal',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const LoginScreen(),
      ),
    );
  }
}

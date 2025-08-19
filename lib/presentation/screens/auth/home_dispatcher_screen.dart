// lib/presentation/screens/auth/home_dispatcher_screen.dart
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_registration_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_main_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDispatcherScreen extends StatefulWidget {
  final String role;
  final String fullName; // <-- AÑADIDO
  final String email; // <-- AÑADIDO

  const HomeDispatcherScreen({
    super.key,
    required this.role,
    required this.fullName, // <-- AÑADIDO
    required this.email, // <-- AÑADIDO
  });

  @override
  State<HomeDispatcherScreen> createState() => _HomeDispatcherScreenState();
}

class _HomeDispatcherScreenState extends State<HomeDispatcherScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.role == 'gestante') {
      context.read<PatientBloc>().add(GetPatient());
    } else if (widget.role == 'personal_salud') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => PersonnelMainScreen(
                    // <-- PASAMOS LOS DATOS
                    fullName: widget.fullName,
                    email: widget.email,
                  )),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rol "${widget.role}" no reconocido.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientLoaded) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PatientMainScreen()),
          );
        } else if (state is PatientProfileNotFound) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => const PatientRegistrationScreen()),
          );
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

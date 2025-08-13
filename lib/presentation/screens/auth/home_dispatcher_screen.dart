import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_registration_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_main_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDispatcherScreen extends StatefulWidget {
  final String role;
  const HomeDispatcherScreen({super.key, required this.role});

  @override
  State<HomeDispatcherScreen> createState() => _HomeDispatcherScreenState();
}

class _HomeDispatcherScreenState extends State<HomeDispatcherScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.role == 'gestante') {
      // Inicia la comprobación del perfil de la paciente
      context.read<PatientBloc>().add(GetPatient());
    } else if (widget.role == 'personal_salud') {
      // Navega directamente para el personal de salud
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PersonnelHomeScreen()),
        );
      });
    } else {
      // Manejar rol no reconocido
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rol "${widget.role}" no reconocido.')),
        );
        // Aquí podrías navegar de vuelta al login
        // Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mientras se decide a dónde navegar, muestra un indicador de carga.
    // Para el rol 'gestante', el listener se encargará de la navegación.
    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientLoaded) {
          // Perfil encontrado, ir al dashboard de la paciente
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PatientMainScreen()),
          );
        } else if (state is PatientError) {
          // Perfil no encontrado, ir a la pantalla de registro
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => const PatientRegistrationScreen()),
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

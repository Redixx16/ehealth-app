// lib/presentation/screens/patient/patient_profile_page.dart
import 'package:flutter/material.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_home_screen.dart';

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Aquí reutilizamos la vista de perfil que ya habías creado.
      body: const PatientHomeScreen(),
    );
  }
}

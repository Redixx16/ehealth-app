// lib/presentation/screens/personnel/personnel_profile_screen.dart
import 'package:ehealth_app/presentation/screens/personnel/personnel_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores consistente
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);

class PersonnelProfileScreen extends StatelessWidget {
  const PersonnelProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    const String personnelName = 'Dr. Carlos Solís';
    const String personnelSpecialty = 'Ginecólogo Obstetra';
    const String personnelEmail = 'c.solis@minsa.gob.pe';
    const String personnelPhone = '+51 987 654 321';

    return Scaffold(
      backgroundColor: kPersonnelBackgroundColor,
      appBar: AppBar(
        title: Text('Mi Perfil',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        // El botón de retroceso es manejado automáticamente por la navegación
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: <Widget>[
          _buildProfileHeader(personnelName, personnelSpecialty),
          const SizedBox(height: 30),
          _buildInfoSection(personnelEmail, personnelPhone),
          const SizedBox(height: 20),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, String specialty) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: kPersonnelPrimaryColor,
          child: Icon(
            Icons.local_hospital_outlined,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          specialty,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String email, String phone) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Información de Contacto",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Divider(height: 24),
          _buildContactInfoRow(Icons.email_outlined, email),
          const SizedBox(height: 16),
          _buildContactInfoRow(Icons.phone_outlined, phone),
        ],
      ),
    );
  }

  Widget _buildContactInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kPersonnelAccentColor, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.edit_outlined,
            text: 'Editar Perfil',
            onTap: () {
              // Lógica para editar el perfil
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.lock_outline,
            text: 'Cambiar Contraseña',
            onTap: () {
              // Lógica para cambiar contraseña
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.notifications_outlined,
            text: 'Configurar Notificaciones',
            onTap: () {
              // Lógica para la configuración de notificaciones
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey.shade700),
          title: Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

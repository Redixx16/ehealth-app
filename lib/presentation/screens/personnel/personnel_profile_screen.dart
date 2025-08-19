// lib/presentation/screens/personnel/personnel_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores para la vista del personal
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);

class PersonnelProfileScreen extends StatelessWidget {
  const PersonnelProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para el perfil
    const String personnelName = 'Dr. Carlos Solís';
    const String personnelEmail = 'c.solis@minsa.gob.pe';
    const String personnelId = 'CMP: 78945';

    return Scaffold(
      backgroundColor: kPersonnelBackgroundColor,
      // Usamos un GlobalKey para poder abrir el Drawer desde el AppBar
      key: GlobalKey<ScaffoldState>(),
      appBar: AppBar(
        backgroundColor: kPersonnelBackgroundColor,
        elevation: 0,
        // Botón para abrir el Drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      // El Drawer es el menú lateral deslizable
      drawer: _buildDrawer(context, personnelName, personnelEmail),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildProfileHeader(personnelName, personnelId),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildActionsCard(context),
          ],
        ),
      ),
    );
  }

  // Widget para el menú lateral
  Widget _buildDrawer(BuildContext context, String name, String email) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            accountEmail: Text(email, style: GoogleFonts.poppins()),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital,
                  color: kPersonnelPrimaryColor, size: 40),
            ),
            decoration: const BoxDecoration(
              color: kPersonnelPrimaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configuración de la cuenta'),
            onTap: () {
              Navigator.pop(context);
              // Futuro: Navegar a la pantalla de configuración
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Generar Reportes'),
            onTap: () {
              Navigator.pop(context);
              // Futuro: Navegar a la pantalla de reportes
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Ayuda y Soporte'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              // Lógica para cerrar sesión
            },
          ),
        ],
      ),
    );
  }

  // Widget para la cabecera del perfil
  Widget _buildProfileHeader(String name, String id) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: kPersonnelPrimaryColor,
          child: Icon(Icons.local_hospital, size: 60, color: Colors.white),
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
        Text(
          id,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Widget para la tarjeta de información de contacto
  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone_outlined, 'Teléfono', '+51 987 654 321'),
            const Divider(height: 24),
            _buildInfoRow(Icons.location_on_outlined, 'Posta Médica',
                'Bambamarca Centro'),
            const Divider(height: 24),
            _buildInfoRow(Icons.work_outline, 'Especialidad', 'Obstetricia'),
          ],
        ),
      ),
    );
  }

  // Widget para la tarjeta de acciones rápidas
  Widget _buildActionsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_outlined,
                  color: kPersonnelPrimaryColor),
              title: const Text('Editar mi información'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_reset_outlined,
                  color: kPersonnelPrimaryColor),
              title: const Text('Cambiar contraseña'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(color: Colors.grey.shade700),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}

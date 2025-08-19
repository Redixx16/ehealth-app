// lib/presentation/screens/personnel/personnel_main_screen.dart
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_dashboard_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_patients_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/injection_container.dart' as di;

// Paleta de colores
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);

class PersonnelMainScreen extends StatefulWidget {
  const PersonnelMainScreen({super.key});

  @override
  State<PersonnelMainScreen> createState() => _PersonnelMainScreenState();
}

class _PersonnelMainScreenState extends State<PersonnelMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PersonnelDashboardScreen(),
    const PersonnelPatientsListScreen(),
    const Center(child: Text('Agenda Completa (Próximamente)')),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Mis Pacientes',
    'Agenda',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      drawer: const _PersonnelDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: kPersonnelPrimaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}

class _PersonnelDrawer extends StatelessWidget {
  const _PersonnelDrawer();

  @override
  Widget build(BuildContext context) {
    const String personnelName = 'Dr. Carlos Solís';
    const String personnelEmail = 'c.solis@minsa.gob.pe';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(personnelName,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(personnelEmail, style: GoogleFonts.poppins()),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital,
                  color: kPersonnelPrimaryColor, size: 40),
            ),
            decoration: const BoxDecoration(color: kPersonnelPrimaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text('Mi Perfil', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
              // Lógica para ir al perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: Text('Generar Reportes', style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text('Configuración', style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          const Spacer(),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Cerrar sesión',
                style: GoogleFonts.poppins(color: Colors.redAccent)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt_token');
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => di.locator<LoginBloc>(),
                        child: const LoginScreen())),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

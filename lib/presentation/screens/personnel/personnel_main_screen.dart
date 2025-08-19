import 'package:ehealth_app/presentation/screens/appointments/create_appointment_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_dashboard_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_patients_list_screen.dart';
import 'package:ehealth_app/presentation/widgets/custom_floating_nav_bar.dart';
import 'package:ehealth_app/presentation/widgets/personnel_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores actualizada para el personal
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1); // Azul oscuro original
const Color kPersonnelAccentColor = Color(0xFF1976D2); // Azul más claro
const Color kPersonnelBackgroundColor =
    Color(0xFFF5F7FA); // Fondo gris claro original
const Color kPersonnelTextColor = Color(0xFF333333); // Texto oscuro

class PersonnelMainScreen extends StatefulWidget {
  const PersonnelMainScreen({super.key});

  @override
  State<PersonnelMainScreen> createState() => _PersonnelMainScreenState();
}

class _PersonnelMainScreenState extends State<PersonnelMainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<CustomNavBarItem> _navBarItems = [
    CustomNavBarItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    CustomNavBarItem(icon: Icons.people_outline, label: 'Pacientes'),
    CustomNavBarItem(icon: Icons.calendar_month_outlined, label: 'Agenda'),
  ];

  final List<Widget> _screens = [
    const PersonnelDashboardScreen(),
    const PersonnelPatientsListScreen(),
    const Center(child: Text('Agenda Completa (Próximamente)')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCtaTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAppointmentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPersonnelBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: kPersonnelTextColor),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          _navBarItems[_selectedIndex].label,
          style: GoogleFonts.poppins(
            color: kPersonnelTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const PersonnelDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onCtaTapped: _onCtaTapped,
        items: _navBarItems,
      ),
    );
  }
}

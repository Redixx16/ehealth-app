// lib/presentation/screens/personnel/personnel_main_screen.dart
import 'package:ehealth_app/presentation/screens/personnel/personnel_dashboard_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_patients_list_screen.dart';
import 'package:ehealth_app/presentation/widgets/personnel_drawer.dart'; // Importamos el nuevo drawer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Definimos la paleta aquí para fácil acceso en esta sección
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);

class PersonnelMainScreen extends StatefulWidget {
  const PersonnelMainScreen({super.key});

  @override
  State<PersonnelMainScreen> createState() => _PersonnelMainScreenState();
}

class _PersonnelMainScreenState extends State<PersonnelMainScreen> {
  int _selectedIndex = 0;

  // Lista de las diferentes vistas que se mostrarán
  final List<Widget> _screens = [
    const PersonnelDashboardScreen(),
    const PersonnelPatientsListScreen(),
    const Center(child: Text('Agenda Completa (Próximamente)')),
  ];

  // Títulos correspondientes a cada vista
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
      backgroundColor: kPersonnelBackgroundColor,
      // Usamos un GlobalKey para poder abrir el Drawer desde el AppBar
      key: GlobalKey<ScaffoldState>(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // Botón para abrir el Drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // El Drawer es el menú lateral deslizable
      drawer: const PersonnelDrawer(),
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

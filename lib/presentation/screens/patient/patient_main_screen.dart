import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_profile_page.dart';
import 'package:flutter/material.dart';
// Mantén tus imports
import 'package:ehealth_app/presentation/screens/appointments/mockup_citas_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/achievements_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/education_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/notifications_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({super.key});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _PatientHomeTab(),
    MockupCitasScreen(),
    AchievementsScreen(),
    EducationScreen(),
    NotificationsScreen(),
  ];

  final List<String> _titles = const [
    'Inicio',
    'Citas',
    'Logros',
    'Educación',
    'Notificaciones',
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
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: const _PatientDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6A5AE0),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 5,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Citas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              activeIcon: Icon(Icons.emoji_events),
              label: 'Logros'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Educación'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Notificaciones'),
        ],
      ),
    );
  }
}

// --- Drawer (sin cambios) ---
// --- Drawer con la nueva navegación para "Mi Perfil" ---
class _PatientDrawer extends StatelessWidget {
  const _PatientDrawer();
  @override
  Widget build(BuildContext context) {
    const String fullName = 'Anaís García';
    const String email = 'anais.garcia@email.com';
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(fullName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF6A5AE0)),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF8A7AFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Mi Perfil'),
            // ==================================================================
            // CORRECCIÓN: Navegación a una nueva pantalla de perfil.
            // ==================================================================
            onTap: () {
              // Primero, cierra el menú lateral
              Navigator.of(context).pop();
              // Luego, navega a la nueva pantalla de perfil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientProfilePage(),
                ),
              );
            },
          ),
          ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Configuración'),
              onTap: () {}),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('jwt_token');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => LoginBloc(
                              authRemoteDataSource: AuthRemoteDataSource()),
                          child: LoginScreen())),
                  (Route<dynamic> route) => false,
                );
              }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('eHealth Prenatal v1.0',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

// --- Tab de Inicio con contenido útil y no redundante ---
class _PatientHomeTab extends StatelessWidget {
  const _PatientHomeTab();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¡Hola, Anaís!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Cuidamos de ti y tu bebé en cada paso.',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 24),

            // CORRECCIÓN: La sección "Acceso Rápido" se reemplaza por "Registro Diario"
            // con acciones únicas que NO están en el BottomNavigationBar.
            const Text('Registro Diario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionCard(context, 'Registrar Síntoma',
                    Icons.sick_outlined, Colors.orange),
                _buildQuickActionCard(context, 'Presión Arterial',
                    Icons.favorite_border, Colors.red),
                _buildQuickActionCard(context, 'Mov. Fetales',
                    Icons.child_friendly_outlined, Colors.blue),
                _buildQuickActionCard(context, 'Emergencia',
                    Icons.local_hospital_outlined, Colors.red.shade800),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Próxima Cita',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildNextAppointmentCard(),
            const SizedBox(height: 24),

            const Text('Aprende más',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildEducationArticleCard('Nutrición',
                      'assets/images/nutrition.png', const Color(0xFFE0F7FA)),
                  const SizedBox(width: 16),
                  _buildEducationArticleCard('Ejercicios',
                      'assets/images/exercise.png', const Color(0xFFFFF3E0)),
                  const SizedBox(width: 16),
                  _buildEducationArticleCard('Alertas',
                      'assets/images/alert.png', const Color(0xFFFFEBEE)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets auxiliares para un código más limpio ---
  Widget _buildQuickActionCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  textAlign: TextAlign.center),
            ]),
          ),
        ));
  }

  Widget _buildNextAppointmentCard() {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF6A5AE0), Color(0xFF8A7AFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF6A5AE0).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Control Prenatal Mensual',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              SizedBox(height: 12),
              Row(children: [
                Icon(Icons.person_outline, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text('Dr. Carlos Solís',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ]),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.calendar_today_outlined,
                    color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text('Martes, 30 de julio',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Spacer(),
                Icon(Icons.access_time_outlined,
                    color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text('10:00 AM',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ]),
            ]));
  }

  Widget _buildEducationArticleCard(
      String title, String imagePath, Color bgColor) {
    return Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/ehealth_logo.png'), // Placeholder
                              fit: BoxFit.contain,
                              opacity: 0.5)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2),
                    ),
                  ])),
        ));
  }
}

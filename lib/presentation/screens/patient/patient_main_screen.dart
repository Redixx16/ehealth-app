// lib/presentation/screens/patient/patient_main_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart'; // <-- Importar entidad
import 'package:ehealth_app/domain/entities/patient.dart'; // <-- Importar entidad
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart'; // <-- Importar BLoC de citas
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart'; // <-- Importar BLoC de paciente
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ehealth_app/presentation/screens/appointments/mockup_citas_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/achievements_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/education_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/notifications_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/pregnancy_timeline_screen.dart';
import 'package:ehealth_app/presentation/screens/patient/gamification/progress_stats_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/injection_container.dart' as di;

// Paleta de colores consistente con el resto de la app
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class PatientMainScreen extends StatefulWidget {
  const PatientMainScreen({super.key});

  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // <-- 1. Cargar las citas tan pronto como la pantalla se inicie
    context.read<AppointmentsBloc>().add(FetchAppointments());
  }

  final List<Widget> _screens = const [
    _PatientHomeTab(),
    MockupCitasScreen(),
    AchievementsScreen(),
    EducationScreen(),
    NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Recargar citas al volver a la pestaña de inicio
        context.read<AppointmentsBloc>().add(FetchAppointments());
        break;
      case 1:
        break;
      case 2:
        context.read<GamificationBloc>().add(const LoadAchievements(userId: 1));
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // <-- 2. Usar un BlocBuilder para obtener los datos del paciente y mostrarlos
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kTextColor),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            String title = '¡Hola!';
            if (state is PatientLoaded) {
              // Extraemos el primer nombre para un saludo más personal
              final firstName = state.patient.fullName.split(' ').first;
              title = '¡Hola, $firstName!';
            }
            return Text(
              title,
              style: GoogleFonts.poppins(
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientProfilePage()));
              },
              child: const CircleAvatar(
                backgroundColor: kPrimaryLightColor,
                child: Icon(Icons.person, color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
      drawer: const _PatientDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey.shade400,
        elevation: 10,
        selectedLabelStyle:
            GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Citas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined), label: 'Logros'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined), label: 'Educación'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined), label: 'Alertas'),
        ],
      ),
    );
  }
}

class _PatientDrawer extends StatelessWidget {
  const _PatientDrawer();
  @override
  Widget build(BuildContext context) {
    // <-- 3. Usar otro BlocBuilder para los datos del menú lateral
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        String fullName = 'Paciente';
        String email = 'Cargando...';

        if (state is PatientLoaded) {
          fullName = state.patient.fullName;
          // Asumimos que no tenemos el email en el modelo Patient, puedes añadirlo si lo necesitas
          email = 'DNI: ${state.patient.nationalId}';
        }

        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(fullName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                accountEmail: Text(email, style: GoogleFonts.poppins()),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: kPrimaryColor),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryLightColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('Mi Perfil', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientProfilePage()));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text('Configuración', style: GoogleFonts.poppins()),
                  onTap: () {}),
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('eHealth Prenatal v1.0',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[500], fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PatientHomeTab extends StatelessWidget {
  const _PatientHomeTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del Día',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextColor)),
          const SizedBox(height: 8),
          Text('Tus acciones rápidas para hoy.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildQuickActionCard(
                context,
                'Mi Embarazo',
                Icons.flag_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PregnancyTimelineScreen()),
                  );
                },
              ),
              _buildQuickActionCard(
                context,
                'Mi Progreso',
                Icons.analytics_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProgressStatsScreen()),
                  );
                },
              ),
              _buildQuickActionCard(
                  context, 'Presión Arterial', Icons.favorite_border),
              _buildQuickActionCard(
                  context, 'Emergencia', Icons.local_hospital_outlined,
                  isEmergency: true),
            ],
          ),
          const SizedBox(height: 32),
          Text('Próxima Cita',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextColor)),
          const SizedBox(height: 16),
          // <-- 4. Usar un BlocBuilder para obtener las citas y mostrar la correcta
          BlocBuilder<AppointmentsBloc, AppointmentsState>(
            builder: (context, state) {
              if (state is AppointmentsLoadSuccess) {
                // Filtra y ordena las citas para encontrar la próxima
                final upcomingAppointments = state.appointments
                    .where((a) => a.appointmentDate.isAfter(DateTime.now()))
                    .toList()
                  ..sort(
                      (a, b) => a.appointmentDate.compareTo(b.appointmentDate));

                if (upcomingAppointments.isNotEmpty) {
                  return _buildNextAppointmentCard(upcomingAppointments
                      .first); // Muestra la primera de la lista
                } else {
                  return _buildNoUpcomingAppointmentsCard(); // Muestra un mensaje si no hay
                }
              }
              // Muestra un indicador de carga mientras se obtienen los datos
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 32),
          Text('Aprende esta semana',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextColor)),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildEducationArticleCard(
                    context,
                    'Nutrición',
                    Icons.restaurant_menu_outlined,
                    kPrimaryLightColor.withOpacity(0.5)),
                const SizedBox(width: 16),
                _buildEducationArticleCard(
                    context,
                    'Ejercicios',
                    Icons.fitness_center_outlined,
                    kPrimaryLightColor.withOpacity(0.5)),
                const SizedBox(width: 16),
                _buildEducationArticleCard(
                    context,
                    'Señales de Alerta',
                    Icons.warning_amber_rounded,
                    kPrimaryLightColor.withOpacity(0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context, String title, IconData icon,
      {bool isEmergency = false, VoidCallback? onTap}) {
    final color = isEmergency ? Colors.red.shade700 : kPrimaryColor;
    return Container(
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  // <-- 5. El método ahora recibe un objeto Appointment
  Widget _buildNextAppointmentCard(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Control Prenatal Mensual',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.person_outline, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            // El nombre del doctor podría venir de la API en el futuro
            Text('Dr. Carlos Solís',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            // ================== CORRECCIÓN 1 de 2 ==================
            // Usamos la fecha real de la cita y la convertimos a local
            Text(
                DateFormat('EEEE, dd \'de\' MMMM', 'es_ES')
                    .format(appointment.appointmentDate.toLocal()),
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.access_time_outlined,
                color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            // ================== CORRECCIÓN 2 de 2 ==================
            // Usamos la hora real de la cita y la convertimos a local
            Text(
                DateFormat('hh:mm a')
                    .format(appointment.appointmentDate.toLocal()),
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
          ]),
        ],
      ),
    );
  }

  // <-- 6. Nuevo widget para mostrar cuando no hay citas
  Widget _buildNoUpcomingAppointmentsCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'No tienes citas programadas por el momento.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildEducationArticleCard(
      BuildContext context, String title, IconData icon, Color bgColor) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                child:
                    Icon(icon, size: 50, color: kPrimaryColor.withOpacity(0.9)),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

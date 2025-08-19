// lib/presentation/screens/personnel/personnel_home_screen.dart

import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:ehealth_app/presentation/screens/appointments/create_appointment_screen.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/injection_container.dart' as di;

// Paleta de colores para la vista del personal
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1); // Azul oscuro
const Color kPersonnelAccentColor = Color(0xFF1976D2); // Azul más claro
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);

class PersonnelHomeScreen extends StatefulWidget {
  const PersonnelHomeScreen({super.key});

  @override
  State<PersonnelHomeScreen> createState() => _PersonnelHomeScreenState();
}

class _PersonnelHomeScreenState extends State<PersonnelHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.locator<AppointmentsBloc>()..add(FetchAppointments()),
      child: Scaffold(
        backgroundColor: kPersonnelBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            'Dashboard de Gestión',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black54),
              tooltip: 'Cerrar Sesión',
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('jwt_token');
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                            create: (context) => di.locator<LoginBloc>(),
                            child: const LoginScreen())),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<AppointmentsBloc>().add(FetchAppointments());
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: _buildDashboardMetrics(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      'Agenda de Citas',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: kPersonnelBackgroundColor,
                  toolbarHeight: 0,
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: kPersonnelPrimaryColor,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: kPersonnelPrimaryColor,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Próximas'),
                      Tab(text: 'Hoy'),
                      Tab(text: 'Historial'),
                    ],
                  ),
                ),
              ];
            },
            body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoadSuccess) {
                  return _buildAppointmentsContent(state.appointments);
                }
                if (state is AppointmentsLoadFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CreateAppointmentScreen()),
            );
            if (result == true && context.mounted) {
              context.read<AppointmentsBloc>().add(FetchAppointments());
            }
          },
          backgroundColor: kPersonnelPrimaryColor,
          foregroundColor: Colors.white,
          tooltip: 'Crear Nueva Cita',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDashboardMetrics() {
    // Por ahora, estos datos son estáticos. En el futuro se pueden conectar a un BLoC.
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricCard('8', 'Citas de Hoy', Icons.today, Colors.orange),
          _buildMetricCard(
              '25', 'Pacientes Activas', Icons.people, Colors.blue),
          _buildMetricCard('3', 'Alertas', Icons.warning, Colors.red),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsContent(List<Appointment> appointments) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final upcoming = appointments
        .where((a) => a.appointmentDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    final today = upcoming
        .where((a) =>
            a.appointmentDate.isAfter(todayStart) &&
            a.appointmentDate.isBefore(todayEnd))
        .toList();

    final history = appointments
        .where((a) => a.appointmentDate.isBefore(now))
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

    return TabBarView(
      controller: _tabController,
      children: [
        _buildAppointmentList(upcoming, 'No hay citas próximas.'),
        _buildAppointmentList(today, 'No hay citas programadas para hoy.'),
        _buildAppointmentList(history, 'No hay citas en el historial.'),
      ],
    );
  }

  Widget _buildAppointmentList(
      List<Appointment> appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: appointments.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        return _AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final statusColor = appointment.status == 'completada'
        ? Colors.green.shade600
        : (appointment.status == 'cancelada'
            ? Colors.red.shade600
            : kPersonnelAccentColor);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailScreen(
                  appointment: appointment, showEditButton: true),
            ),
          );
          if (result == true && context.mounted) {
            context.read<AppointmentsBloc>().add(FetchAppointments());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patient?.fullName ?? 'Paciente no asignado',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM/yyyy, hh:mm a')
                            .format(appointment.appointmentDate.toLocal()),
                        style: GoogleFonts.poppins(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: GoogleFonts.poppins(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

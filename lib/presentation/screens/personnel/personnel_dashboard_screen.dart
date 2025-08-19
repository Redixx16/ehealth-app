// lib/presentation/screens/personnel/personnel_dashboard_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:ehealth_app/presentation/screens/appointments/create_appointment_screen.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:ehealth_app/presentation/screens/personnel/personnel_profile_screen.dart';
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

class PersonnelDashboardScreen extends StatelessWidget {
  const PersonnelDashboardScreen({super.key});

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
            'Dashboard', // Título más corto para dar espacio al nuevo botón
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // ================== AÑADIDO ==================
            // Botón para navegar a la pantalla de perfil
            IconButton(
              icon: const Icon(Icons.account_circle_outlined,
                  color: Colors.black54, size: 28),
              tooltip: 'Mi Perfil',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonnelProfileScreen()),
                );
              },
            ),
            // ===============================================
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
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<AppointmentsBloc>().add(FetchAppointments());
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildDashboardMetrics()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Citas para Hoy',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              BlocBuilder<AppointmentsBloc, AppointmentsState>(
                builder: (context, state) {
                  if (state is AppointmentsLoadSuccess) {
                    final now = DateTime.now();
                    final todayStart = DateTime(now.year, now.month, now.day);
                    final todayEnd = todayStart.add(const Duration(days: 1));

                    final todayAppointments = state.appointments
                        .where((a) =>
                            a.appointmentDate.isAfter(todayStart) &&
                            a.appointmentDate.isBefore(todayEnd))
                        .toList();

                    return _buildAppointmentList(todayAppointments);
                  }
                  if (state is AppointmentsLoadFailure) {
                    return SliverFillRemaining(
                        child: Center(child: Text('Error: ${state.error}')));
                  }
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenid@ de vuelta,',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Personal de Salud', // Esto puede ser dinámico en el futuro
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        // ================== CORRECCIÓN CLAVE AQUÍ ==================
        // Cambiamos el valor de 1.8 a 1.6 para dar más altura a las tarjetas.
        childAspectRatio: 1.6,
        // ==========================================================
        children: [
          _buildMetricCard(
              '8', 'Citas de Hoy', Icons.today_outlined, kPersonnelAccentColor),
          _buildMetricCard('25', 'Pacientes Activas', Icons.people_alt_outlined,
              Colors.green),
          _buildMetricCard('3', 'Alertas Pendientes',
              Icons.warning_amber_rounded, Colors.orange),
          _buildMetricCard(
              '72%', 'Adherencia', Icons.check_circle_outline, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: color.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
          child: Center(
            child: Text(
              'No hay citas programadas para hoy.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _AppointmentCard(appointment: appointments[index]);
        },
        childCount: appointments.length,
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
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
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: kPersonnelAccentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_outline,
                    color: kPersonnelAccentColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patient?.fullName ?? 'Paciente no asignado',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a')
                          .format(appointment.appointmentDate.toLocal()),
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/presentation/screens/appointments/mockup_citas_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kTextColor = Color(0xFF424242);

class MockupCitasScreen extends StatelessWidget {
  const MockupCitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.locator<AppointmentsBloc>()..add(FetchAppointments()),
      child: Scaffold(
        // Ya no necesita su propio AppBar, usa el de PatientMainScreen
        body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsInitial || state is AppointmentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentsLoadSuccess) {
              if (state.appointments.isEmpty) {
                return _buildEmptyState();
              }
              return _buildAppointmentsList(context, state.appointments);
            }
            if (state is AppointmentsLoadFailure) {
              return Center(
                child: Text(
                  'Error al cargar las citas: ${state.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red.shade700),
                ),
              );
            }
            return const Center(child: Text('Estado inesperado.'));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            'Aún no tienes citas',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Contacta a tu centro de salud para agendar tu próximo control.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(
      BuildContext context, List<Appointment> appointments) {
    // Separamos las citas futuras de las pasadas
    final upcomingAppointments = appointments
        .where((a) => a.appointmentDate.isAfter(DateTime.now()))
        .toList();
    final pastAppointments = appointments
        .where((a) => a.appointmentDate.isBefore(DateTime.now()))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Tu Próxima Cita',
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        const SizedBox(height: 16),
        if (upcomingAppointments.isNotEmpty)
          _buildNextAppointmentCard(context, upcomingAppointments.first)
        else
          _buildNoUpcomingCard(),
        const SizedBox(height: 32),
        Text(
          'Historial de Citas',
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
        ),
        const SizedBox(height: 16),
        if (pastAppointments.isNotEmpty)
          ...pastAppointments
              .map((app) => _buildPastAppointmentTile(context, app))
        else
          Text(
            'No tienes citas pasadas.',
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
          ),
      ],
    );
  }

  Widget _buildNextAppointmentCard(
      BuildContext context, Appointment appointment) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Control Prenatal',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.calendar_today_outlined,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 10),
              Text(
                DateFormat('EEEE, dd \'de\' MMMM', 'es_ES')
                    .format(appointment.appointmentDate.toLocal()),
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.access_time_outlined,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 10),
              Text(
                DateFormat('hh:mm a')
                    .format(appointment.appointmentDate.toLocal()),
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildNoUpcomingCard() {
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

  Widget _buildPastAppointmentTile(
      BuildContext context, Appointment appointment) {
    final statusColor = appointment.status == 'completada'
        ? Colors.green.shade600
        : (appointment.status == 'cancelada'
            ? Colors.red.shade600
            : Colors.grey.shade600);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              const Icon(Icons.calendar_month_outlined, color: kPrimaryColor),
        ),
        title: Text(
          DateFormat('dd \'de\' MMMM, yyyy', 'es_ES')
              .format(appointment.appointmentDate.toLocal()),
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: kTextColor),
        ),
        subtitle: Text(
          'Estado: ${appointment.status}',
          style: GoogleFonts.poppins(
              color: statusColor, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailScreen(appointment: appointment),
            ),
          );
        },
      ),
    );
  }
}

// lib/presentation/screens/personnel/personnel_dashboard_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:ehealth_app/presentation/screens/appointments/create_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;

class PersonnelDashboardScreen extends StatelessWidget {
  const PersonnelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtenemos tu tema

    return BlocProvider(
      create: (context) =>
          di.locator<AppointmentsBloc>()..add(FetchAppointments()),
      child: Scaffold(
        // El AppBar ahora es manejado por PersonnelMainScreen
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<AppointmentsBloc>().add(FetchAppointments());
          },
          child: CustomScrollView(
            slivers: [
              _buildHeader(context, "Dr. Carlos Solís"),
              _buildTodaySummary(context),
              _buildSectionHeader(context, "Próximas Citas"),
              _buildAppointmentsList(context),
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
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context, String name) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenid@ de vuelta,',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            Text(
              name,
              style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTodaySummary(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: _SummaryCard(
                value: '8',
                label: 'Citas Hoy',
                icon: Icons.calendar_today,
                // Usamos TU color primario
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                value: '3',
                label: 'Alertas',
                icon: Icons.warning_amber_rounded,
                color: Colors.orange.shade700, // Un color estándar para alertas
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return BlocBuilder<AppointmentsBloc, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoadSuccess) {
          final now = DateTime.now();
          final todayStart = DateTime(now.year, now.month, now.day);
          final todayAppointments = state.appointments
              .where((a) => a.appointmentDate.isAfter(todayStart))
              .toList();

          if (todayAppointments.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text("No hay citas programadas."),
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _AppointmentTile(appointment: todayAppointments[index]),
                childCount: todayAppointments.length,
              ),
            ),
          );
        }
        if (state is AppointmentsLoadFailure) {
          return SliverToBoxAdapter(
              child: Center(child: Text('Error: ${state.error}')));
        }
        return const SliverToBoxAdapter(
            child: Center(
                child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        )));
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentTile({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('d', 'es_ES').format(appointment.appointmentDate),
              style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.primaryColor, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('MMM', 'es_ES')
                  .format(appointment.appointmentDate)
                  .toUpperCase(),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.primaryColor),
            ),
          ],
        ),
        title: Text(
          appointment.patient?.fullName ?? 'Paciente no asignado',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Cita a las ${DateFormat('hh:mm a', 'es_ES').format(appointment.appointmentDate.toLocal())}",
          style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
      ),
    );
  }
}

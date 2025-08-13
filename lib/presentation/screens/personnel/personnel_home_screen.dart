// lib/presentation/screens/personnel/personnel_home_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/bloc/login/login_bloc.dart';
import 'package:ehealth_app/data/datasources/auth_remote_data_source.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:ehealth_app/presentation/screens/appointments/create_appointment_screen.dart';
import 'package:ehealth_app/presentation/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehealth_app/injection_container.dart'
    as di; // <-- Importa GetIt

class PersonnelHomeScreen extends StatelessWidget {
  const PersonnelHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Ahora usamos nuestro locator para crear la instancia del BLoC
      create: (context) =>
          di.locator<AppointmentsBloc>()..add(FetchAppointments()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateAppointmentScreen()),
              );
              // Si la pantalla de creación devuelve un resultado (o simplemente al volver),
              // refrescamos la lista de citas.
              if (context.mounted) {
                context.read<AppointmentsBloc>().add(FetchAppointments());
              }
            },
            tooltip: 'Crear Nueva Cita',
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AppointmentsBloc>().add(FetchAppointments());
                  },
                  child: CustomScrollView(
                    slivers: [
                      _buildHeader(context),
                      _buildBody(context, state),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.grey[100],
      elevation: 0,
      title: const Text('Citas Programadas',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _buildBody(BuildContext context, AppointmentsState state) {
    if (state is AppointmentsLoadSuccess) {
      if (state.appointments.isEmpty) {
        return const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No has programado citas.',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final appointment = state.appointments[index];
            return _AppointmentCard(appointment: appointment);
          },
          childCount: state.appointments.length,
        ),
      );
    }
    if (state is AppointmentsLoadFailure) {
      return SliverFillRemaining(
          child: Center(child: Text('Error: ${state.error}')));
    }
    return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        appointment.status == 'completada' ? Colors.green : Colors.blue;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailScreen(
                appointment: appointment, showEditButton: true),
          ),
        );
        // Si la pantalla de detalle devolvió 'true' (porque se eliminó o editó algo)
        // refrescamos la lista.
        if (result == true && context.mounted) {
          context.read<AppointmentsBloc>().add(FetchAppointments());
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paciente: ${appointment.patient?.fullName ?? 'No asignado'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd/MM/yyyy, hh:mm a')
                        .format(appointment.appointmentDate.toLocal()),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  const Text('Estado:'),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
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

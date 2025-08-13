// lib/presentation/screens/appointments/appointment_detail_screen.dart
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_event.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_state.dart';
import 'package:ehealth_app/presentation/screens/appointments/edit_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final bool showEditButton;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
    this.showEditButton = false,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late Appointment _currentAppointment;
  final AppointmentRemoteDataSource _dataSource =
      di.locator<AppointmentRemoteDataSource>();

  @override
  void initState() {
    super.initState();
    _currentAppointment = widget.appointment;
    _refreshAppointmentDetails();
  }

  Future<void> _refreshAppointmentDetails() async {
    try {
      final updatedAppointment =
          await _dataSource.getAppointmentById(_currentAppointment.id);
      if (mounted) {
        setState(() {
          _currentAppointment = updatedAppointment;
        });
      }
    } catch (e) {
      // En un futuro, aquí iría un logger.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.locator<DeleteAppointmentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de la Cita'),
          actions: [
            if (widget.showEditButton)
              BlocBuilder<DeleteAppointmentBloc, DeleteAppointmentState>(
                builder: (context, state) {
                  if (state is DeleteAppointmentLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(color: Colors.black54)),
                    );
                  }
                  return IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Eliminar Cita',
                    onPressed: () => _showDeleteConfirmationDialog(context),
                  );
                },
              ),
          ],
        ),
        body: BlocListener<DeleteAppointmentBloc, DeleteAppointmentState>(
          listener: (context, state) {
            if (state is DeleteAppointmentSuccess) {
              Navigator.of(context)
                  .pop(true); // Devuelve 'true' para indicar éxito
            }
            if (state is DeleteAppointmentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(context),
                const SizedBox(height: 20),
                _buildRecommendationsCard(context),
              ],
            ),
          ),
        ),
        floatingActionButton: widget.showEditButton
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditAppointmentScreen(
                          appointment: _currentAppointment),
                    ),
                  );
                  if (result == true && mounted) {
                    _refreshAppointmentDetails();
                  }
                },
                tooltip: 'Editar Cita',
                child: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _DetailInfoRow(
              icon: Icons.person_outline,
              title: 'Paciente',
              subtitle: _currentAppointment.patient?.fullName ?? 'No asignado',
            ),
            const Divider(height: 24),
            _DetailInfoRow(
              icon: Icons.calendar_today_outlined,
              title: 'Fecha y Hora',
              subtitle: DateFormat('EEEE, dd \'de\' MMMM, hh:mm a', 'es_ES')
                  .format(_currentAppointment.appointmentDate.toLocal()),
            ),
            const Divider(height: 24),
            _DetailInfoRow(
              icon: Icons.info_outline,
              title: 'Estado',
              subtitleWidget: _StatusChip(status: _currentAppointment.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shadowColor: theme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendaciones Médicas',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const Divider(height: 24),
            Text(
              _currentAppointment.recommendations ??
                  'Aún no hay recomendaciones.',
              style: GoogleFonts.poppins(height: 1.5, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirmar Eliminación', style: GoogleFonts.poppins()),
          content: Text(
              '¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<DeleteAppointmentBloc>().add(
                      DeleteButtonPressed(
                          appointmentId: _currentAppointment.id),
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;

  const _DetailInfoRow(
      {required this.icon,
      required this.title,
      this.subtitle,
      this.subtitleWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(color: Colors.grey[700])),
              const SizedBox(height: 4),
              subtitleWidget ??
                  Text(
                    subtitle ?? '',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'completada'
        ? Colors.green.shade600
        : (status == 'cancelada'
            ? Colors.red.shade600
            : Theme.of(context).primaryColor);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
            color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

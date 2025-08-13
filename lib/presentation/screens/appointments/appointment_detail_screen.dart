// lib/presentation/screens/appointment_detail_screen.dart
import 'package:ehealth_app/data/datasources/appointment_remote_data_source.dart';
import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_event.dart';
import 'package:ehealth_app/presentation/bloc/delete_appointment/delete_appointment_state.dart';
import 'package:ehealth_app/presentation/screens/appointments/edit_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
  final AppointmentRemoteDataSource _dataSource = AppointmentRemoteDataSource();

  @override
  void initState() {
    super.initState();
    _currentAppointment = widget.appointment;
    _refreshAppointmentDetails(); // Carga los detalles más recientes al entrar
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
      print("Error al refrescar la cita: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAppointmentBloc(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Detalle de la Cita'),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          foregroundColor: Colors.black87,
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
                // Sección de Información General
                _buildInfoCard(context),
                const SizedBox(height: 20),
                // Sección de Recomendaciones
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
                  // Si la pantalla de edición devuelve 'true', refrescamos
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

  // Widget para la tarjeta de información principal
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  // Widget para la tarjeta de recomendaciones
  Widget _buildRecommendationsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendaciones Médicas',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Text(
              _currentAppointment.recommendations ??
                  'Aún no hay recomendaciones.',
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Llama al BLoC usando el 'context' del diálogo
                // pero el BLoC lo lee del 'context' principal
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
              Text(title, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 4),
              subtitleWidget ??
                  Text(
                    subtitle ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
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
        ? Colors.green
        : (status == 'cancelada' ? Colors.red : Colors.blue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

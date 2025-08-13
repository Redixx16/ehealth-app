import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/update_appointment/update_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/update_appointment/update_appointment_event.dart';
import 'package:ehealth_app/presentation/bloc/update_appointment/update_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Appointment appointment;
  const EditAppointmentScreen({super.key, required this.appointment});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late String _currentStatus;
  late final TextEditingController _recommendationsController;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.appointment.status;
    _recommendationsController =
        TextEditingController(text: widget.appointment.recommendations);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateAppointmentBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Editar Cita')),
        body: BlocListener<UpdateAppointmentBloc, UpdateAppointmentState>(
          listener: (context, state) {
            if (state is UpdateAppointmentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cita actualizada con éxito')),
              );
              Navigator.of(context).pop(); // Vuelve a la pantalla de detalle
            }
            if (state is UpdateAppointmentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (DropdownButton y TextField se mantienen igual)
                DropdownButtonFormField<String>(
                  value: _currentStatus,
                  decoration: const InputDecoration(
                      labelText: 'Estado de la Cita',
                      border: OutlineInputBorder()),
                  items: ['programada', 'completada', 'cancelada']
                      .map((label) =>
                          DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _currentStatus = value);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _recommendationsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: 'Recomendaciones',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true),
                ),
                const Spacer(),
                BlocBuilder<UpdateAppointmentBloc, UpdateAppointmentState>(
                  builder: (context, state) {
                    if (state is UpdateAppointmentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        context.read<UpdateAppointmentBloc>().add(
                              SaveChangesPressed(
                                appointmentId: widget.appointment.id,
                                status: _currentStatus,
                                recommendations:
                                    _recommendationsController.text,
                              ),
                            );
                      },
                      child: const Text('Guardar Cambios'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

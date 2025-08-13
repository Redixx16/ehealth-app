// lib/presentation/screens/appointments/create_appointment_screen.dart
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_event.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;

class CreateAppointmentScreen extends StatelessWidget {
  const CreateAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Proveemos el BLoC a través del árbol de widgets
    return BlocProvider(
      create: (context) => di.locator<CreateAppointmentBloc>(),
      child: const _CreateAppointmentView(),
    );
  }
}

// Widget interno que maneja el estado de la UI (controladores, fecha, etc.)
class _CreateAppointmentView extends StatefulWidget {
  const _CreateAppointmentView();

  @override
  State<_CreateAppointmentView> createState() => _CreateAppointmentViewState();
}

class _CreateAppointmentViewState extends State<_CreateAppointmentView> {
  final _patientIdController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      helpText: 'SELECCIONA LA FECHA',
    );
    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
        helpText: 'SELECCIONA LA HORA',
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Crear Nueva Cita'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: BlocListener<CreateAppointmentBloc, CreateAppointmentState>(
        listener: (context, state) {
          if (state is CreateAppointmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Cita creada exitosamente'),
                  backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          }
          if (state is CreateAppointmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.redAccent),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Datos de la Cita',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _patientIdController,
                    decoration: InputDecoration(
                      labelText: 'ID de la Paciente (Gestante)',
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(Icons.calendar_today_outlined,
                          color: Theme.of(context).primaryColor),
                      title: Text(
                        _selectedDate == null
                            ? 'Seleccionar fecha y hora'
                            : DateFormat('dd/MM/yyyy, hh:mm a')
                                .format(_selectedDate!),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<CreateAppointmentBloc, CreateAppointmentState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: state is CreateAppointmentLoading
                            ? null
                            : () {
                                final patientId =
                                    int.tryParse(_patientIdController.text);
                                if (patientId != null &&
                                    _selectedDate != null) {
                                  context.read<CreateAppointmentBloc>().add(
                                        CreateButtonPressed(
                                          patientId: patientId,
                                          appointmentDate: _selectedDate!,
                                        ),
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Por favor, completa todos los campos')),
                                  );
                                }
                              },
                        child: state is CreateAppointmentLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 3))
                            : const Text('Crear Cita',
                                style: TextStyle(fontSize: 16)),
                      );
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

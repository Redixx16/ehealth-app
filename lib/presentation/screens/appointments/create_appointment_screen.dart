// lib/presentation/screens/appointments/create_appointment_screen.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_bloc.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_event.dart';
import 'package:ehealth_app/presentation/bloc/create_appointment/create_appointment_state.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;

class CreateAppointmentScreen extends StatelessWidget {
  const CreateAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.locator<CreateAppointmentBloc>(),
        ),
        BlocProvider.value(
          value: BlocProvider.of<PatientBloc>(context)..add(GetAllPatients()),
        ),
      ],
      child: const _CreateAppointmentView(),
    );
  }
}

class _CreateAppointmentViewState extends State<_CreateAppointmentView> {
  Patient? _selectedPatient;
  DateTime? _selectedDate;
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
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
          _dateController.text =
              DateFormat('dd/MM/yyyy, hh:mm a').format(_selectedDate!);
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
            Navigator.of(context).pop(true);
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
                  BlocBuilder<PatientBloc, PatientState>(
                    builder: (context, state) {
                      if (state is AllPatientsLoaded) {
                        return DropdownButtonFormField<Patient>(
                          value: _selectedPatient,
                          onChanged: (Patient? newValue) {
                            setState(() {
                              _selectedPatient = newValue;
                            });
                          },
                          items: state.patients.map<DropdownMenuItem<Patient>>(
                              (Patient patient) {
                            return DropdownMenuItem<Patient>(
                              value: patient,
                              child: Text(patient.fullName),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Seleccionar Paciente',
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha y Hora',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
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
                    onTap: () => _selectDate(context),
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
                                if (_selectedPatient != null &&
                                    _selectedDate != null) {
                                  context.read<CreateAppointmentBloc>().add(
                                        CreateButtonPressed(
                                          // <-- CORRECCIÓN: Usamos el userId
                                          patientId: _selectedPatient!.userId,
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

class _CreateAppointmentView extends StatefulWidget {
  const _CreateAppointmentView();

  @override
  State<_CreateAppointmentView> createState() => _CreateAppointmentViewState();
}

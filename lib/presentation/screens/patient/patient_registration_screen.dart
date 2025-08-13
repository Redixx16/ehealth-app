import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo del formulario
  final _fullNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _lastMenstrualPeriodController = TextEditingController();

  DateTime? _dateOfBirth;
  DateTime? _lastMenstrualPeriod;

  @override
  void dispose() {
    // Limpiar los controladores
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _medicalHistoryController.dispose();
    _dateOfBirthController.dispose();
    _lastMenstrualPeriodController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      {required ValueChanged<DateTime> onDateSelected,
      required TextEditingController controller}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onDateSelected(picked);
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido, crea la entidad Patient
      // NOTA: El ID y la fecha probable de parto se calculan en el backend.
      // Aquí pasamos valores dummy que serán ignorados.
      final newPatient = Patient(
        id: 0, // Dummy
        fullName: _fullNameController.text,
        dateOfBirth: _dateOfBirth!,
        nationalId: _nationalIdController.text,
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text,
        lastMenstrualPeriod: _lastMenstrualPeriod!,
        estimatedDueDate: DateTime.now(), // Dummy
        medicalHistory: _medicalHistoryController.text,
      );

      // Despacha el evento al BLoC
      context.read<PatientBloc>().add(CreatePatient(newPatient));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PatientLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Paciente registrada con éxito'),
                backgroundColor: Colors.green,
              ),
            );
            // Navegar a la pantalla de perfil del paciente
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Nombre Completo'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nationalIdController,
                    decoration: const InputDecoration(labelText: 'DNI / Cédula'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateOfBirthController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(
                      context,
                      controller: _dateOfBirthController,
                      onDateSelected: (date) =>
                          setState(() => _dateOfBirth = date),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastMenstrualPeriodController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Última Regla (FUR)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(
                      context,
                      controller: _lastMenstrualPeriodController,
                      onDateSelected: (date) =>
                          setState(() => _lastMenstrualPeriod = date),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _medicalHistoryController,
                    decoration: const InputDecoration(
                        labelText: 'Historial Médico Relevante'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<PatientBloc, PatientState>(
                    builder: (context, state) {
                      if (state is PatientLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Registrar Paciente'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// lib/presentation/screens/patient/patient_registration_screen.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:ehealth_app/presentation/screens/patient/patient_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

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
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kPrimaryColor,
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // ================== CORRECCIÓN CLAVE AQUÍ ==================
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Error: No se encontró ID de usuario. Inicia sesión de nuevo.')),
        );
        return;
      }

      final newPatient = Patient(
        id: 0, // El ID del perfil lo asigna el backend
        userId: userId, // Usamos el ID de usuario que guardamos
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        nationalId: _nationalIdController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        lastMenstrualPeriod: _lastMenstrualPeriod!,
        estimatedDueDate: _lastMenstrualPeriod!
            .add(const Duration(days: 280)), // FPP calculada
        medicalHistory: _medicalHistoryController.text.trim(),
      );
      context.read<PatientBloc>().add(CreatePatient(newPatient));
    }
  }
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: BlocListener<PatientBloc, PatientState>(
        listener: (context, state) {
          if (state is PatientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al registrar: ${state.message}'),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is PatientLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Perfil creado con éxito! Bienvenida.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PatientMainScreen()),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildTextFormField(
                      controller: _fullNameController,
                      labelText: 'Nombre Completo',
                      icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                      controller: _nationalIdController,
                      labelText: 'DNI / Cédula',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildDateFormField(
                      controller: _dateOfBirthController,
                      labelText: 'Fecha de Nacimiento',
                      onDateSelected: (date) =>
                          setState(() => _dateOfBirth = date)),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                      controller: _addressController,
                      labelText: 'Dirección',
                      icon: Icons.home_outlined),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                      controller: _phoneNumberController,
                      labelText: 'Teléfono',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildDateFormField(
                      controller: _lastMenstrualPeriodController,
                      labelText: 'Fecha de Última Regla (FUR)',
                      onDateSelected: (date) =>
                          setState(() => _lastMenstrualPeriod = date)),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                      controller: _medicalHistoryController,
                      labelText: 'Historial Médico Relevante',
                      icon: Icons.medical_services_outlined,
                      maxLines: 3),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completa tu perfil',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Necesitamos algunos datos para empezar a cuidarte.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: kTextColor.withAlpha(153), // Corregido
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int? maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(hintText: labelText, icon: icon),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'Este campo es requerido'
          : null,
    );
  }

  Widget _buildDateFormField({
    required TextEditingController controller,
    required String labelText,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(
          hintText: labelText, icon: Icons.calendar_today_outlined),
      readOnly: true,
      onTap: () => _selectDate(
        context,
        controller: controller,
        onDateSelected: onDateSelected,
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Selecciona una fecha' : null,
    );
  }

  InputDecoration _buildInputDecoration(
      {required String hintText, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: kPrimaryColor.withAlpha(204)), // Corregido
      hintText: hintText,
      hintStyle:
          GoogleFonts.poppins(color: kTextColor.withAlpha(153)), // Corregido
      filled: true,
      fillColor: Colors.white.withAlpha(204), // Corregido
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        final isLoading = state is PatientLoading;
        final screenWidth = MediaQuery.of(context).size.width;
        final buttonWidth = screenWidth - 48;

        return GestureDetector(
          onTap: isLoading ? null : _submitForm,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 50,
            width: isLoading ? 50 : buttonWidth,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryLightColor, kPrimaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(isLoading ? 25 : 30),
              boxShadow: [
                if (!isLoading)
                  BoxShadow(
                    color: kPrimaryColor.withAlpha(102), // Corregido
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
              ],
            ),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5)
                  : Text(
                      'Guardar Perfil',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

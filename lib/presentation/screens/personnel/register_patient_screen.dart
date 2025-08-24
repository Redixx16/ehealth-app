// lib/presentation/screens/personnel/register_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;
import '../../bloc/patient/patient_bloc.dart';
import '../../../domain/entities/patient.dart';

// Paleta de colores consistente con el personal de salud
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);
const Color kTextColor = Color(0xFF424242);

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  
  DateTime? _dateOfBirth;
  DateTime? _lastMenstrualPeriod;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDateOfBirth 
          ? DateTime.now().subtract(const Duration(days: 6570)) // ~18 años atrás
          : DateTime.now().subtract(const Duration(days: 30)), // ~1 mes atrás
      firstDate: isDateOfBirth 
          ? DateTime.now().subtract(const Duration(days: 36500)) // ~100 años atrás
          : DateTime.now().subtract(const Duration(days: 365)), // ~1 año atrás
      lastDate: isDateOfBirth 
          ? DateTime.now().subtract(const Duration(days: 3650)) // ~10 años atrás
          : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPersonnelPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDateOfBirth) {
          _dateOfBirth = picked;
        } else {
          _lastMenstrualPeriod = picked;
        }
      });
    }
  }

  void _onRegisterPatient(BuildContext context) {
    if (_formKey.currentState!.validate() && 
        _dateOfBirth != null && 
        _lastMenstrualPeriod != null) {
      FocusScope.of(context).unfocus();
      
      // ================== CAMBIO CLAVE ==================
      // Usar el evento RegisterPatient del BLoC
      BlocProvider.of<PatientBloc>(context).add(
        RegisterPatient(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          dateOfBirth: _dateOfBirth!,
          address: _addressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          lastMenstrualPeriod: _lastMenstrualPeriod!,
          medicalHistory: _medicalHistoryController.text.trim(),
        ),
      );
      // =================================================
    } else if (_dateOfBirth == null || _lastMenstrualPeriod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona las fechas requeridas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<PatientBloc>(),
      child: Scaffold(
        backgroundColor: kPersonnelBackgroundColor,
        appBar: AppBar(
          backgroundColor: kPersonnelPrimaryColor,
          foregroundColor: Colors.white,
          title: Text(
            'Registrar Paciente',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: BlocConsumer<PatientBloc, PatientState>(
          listener: (context, state) {
            if (state is PatientLoaded) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('¡Paciente registrado exitosamente!'),
                    backgroundColor: Colors.green,
                  ),
                );
              Navigator.of(context).pop();
            } else if (state is PatientError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildForm(),
                      const SizedBox(height: 32),
                      _buildRegisterButton(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nueva Paciente',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Completa los datos de la paciente para registrarla en el sistema.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: kTextColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _fullNameController,
          label: 'Nombre completo',
          icon: Icons.person_outline,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa el nombre completo'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el email';
            }
            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
              return 'Email inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nationalIdController,
          label: 'DNI',
          icon: Icons.badge_outlined,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa el DNI'
              : null,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de nacimiento',
          icon: Icons.cake_outlined,
          value: _dateOfBirth,
          onTap: () => _selectDate(context, true),
          validator: (_) => _dateOfBirth == null ? 'Selecciona la fecha' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          label: 'Dirección',
          icon: Icons.location_on_outlined,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa la dirección'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Teléfono',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa el teléfono'
              : null,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Última menstruación',
          icon: Icons.calendar_today_outlined,
          value: _lastMenstrualPeriod,
          onTap: () => _selectDate(context, false),
          validator: (_) => _lastMenstrualPeriod == null ? 'Selecciona la fecha' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _medicalHistoryController,
          label: 'Historial médico',
          icon: Icons.medical_services_outlined,
          maxLines: 3,
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Ingresa el historial médico'
              : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPersonnelPrimaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPersonnelPrimaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? value,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: kPersonnelPrimaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPersonnelPrimaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          value != null 
              ? DateFormat('dd/MM/yyyy').format(value)
              : 'Seleccionar fecha',
          style: TextStyle(
            color: value != null ? kTextColor : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, PatientState state) {
    final isLoading = state is PatientLoading;

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _onRegisterPatient(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPersonnelPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'Registrar Paciente',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

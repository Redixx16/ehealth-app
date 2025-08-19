// lib/presentation/screens/personnel/personnel_patients_list_screen.dart
import 'package:ehealth_app/domain/entities/patient.dart';
import 'package:ehealth_app/presentation/bloc/patient/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Paleta de colores consistente
const Color kPersonnelPrimaryColor = Color(0xFF0D47A1);
const Color kPersonnelBackgroundColor = Color(0xFFF5F7FA);

class PersonnelPatientsListScreen extends StatefulWidget {
  const PersonnelPatientsListScreen({super.key});

  @override
  State<PersonnelPatientsListScreen> createState() =>
      _PersonnelPatientsListScreenState();
}

class _PersonnelPatientsListScreenState
    extends State<PersonnelPatientsListScreen> {
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(GetAllPatients());
    _searchController.addListener(_filterPatients);
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.fullName.toLowerCase().contains(query) ||
            patient.nationalId.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPersonnelBackgroundColor,
      // El AppBar ahora es manejado por PersonnelMainScreen para consistencia
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocConsumer<PatientBloc, PatientState>(
              listener: (context, state) {
                if (state is AllPatientsLoaded) {
                  setState(() {
                    _allPatients = state.patients;
                    _filteredPatients = state.patients;
                    _filterPatients();
                  });
                }
              },
              builder: (context, state) {
                if (state is PatientLoading && _allPatients.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PatientError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (_filteredPatients.isEmpty) {
                  return Center(
                    child: Text(
                      'No se encontraron pacientes',
                      style: GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _filteredPatients.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemBuilder: (context, index) {
                    return _PatientInfoCard(patient: _filteredPatients[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o DNI...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: kPersonnelBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _PatientInfoCard extends StatelessWidget {
  final Patient patient;
  const _PatientInfoCard({required this.patient});

  String get riskLevel => 'Bajo'; // Esto puede venir de la API en el futuro
  Color _getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'alto':
        return Colors.red.shade700;
      case 'medio':
        return Colors.orange.shade800;
      default:
        return Colors.green.shade700;
    }
  }

  int get weeksOfGestation {
    final now = DateTime.now();
    final difference = now.difference(patient.lastMenstrualPeriod);
    return (difference.inDays / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navegar al detalle del paciente
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      patient.fullName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRiskColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Riesgo: $riskLevel',
                      style: GoogleFonts.poppins(
                          color: _getRiskColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'DNI: ${patient.nationalId}',
                style:
                    GoogleFonts.poppins(color: Colors.grey[700], fontSize: 13),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    '$weeksOfGestation Semanas',
                    Icons.pregnant_woman_outlined,
                  ),
                  _buildInfoChip(
                    'FPP: ${DateFormat('dd/MM/yy').format(patient.estimatedDueDate)}',
                    Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800]),
        ),
      ],
    );
  }
}

// lib/presentation/screens/personnel/personnel_patients_list_screen.dart
import 'dart:async';

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
    extends State<PersonnelPatientsListScreen> with TickerProviderStateMixin {
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Filtro simple: todos / embarazadas (ejemplo) / alto riesgo (placeholder)
  String _activeFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    // Pedimos pacientes
    context.read<PatientBloc>().add(GetAllPatients());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce para evitar filtrar en cada tecla rápidamente
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _filterPatients);
  }

  void _filterPatients() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        final matchesQuery = query.isEmpty ||
            patient.fullName.toLowerCase().contains(query) ||
            patient.nationalId.toLowerCase().contains(query);
        final matchesFilter = _matchesActiveFilter(patient);
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  bool _matchesActiveFilter(Patient p) {
    if (_activeFilter == 'Todos') return true;
    if (_activeFilter == 'Embarazadas') {
      // Si no tienes ese campo, asumimos embarazo si estimatedDueDate != null
      return p.estimatedDueDate != null;
    }
    if (_activeFilter == 'Alto riesgo') {
      // Placeholder: podrías tener p.riskLevel
      return false;
    }
    return true;
  }

  void _setFilter(String filter) {
    if (_activeFilter == filter) return;
    setState(() => _activeFilter = filter);
    _filterPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPersonnelBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchAndFilters(context),
            Expanded(child: _buildListWithBloc()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final total = _allPatients.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: Colors.transparent,
      child: Row(
        children: [
          // Título y subtitulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pacientes',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('$total pacientes registrados',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade700)),
              ],
            ),
          ),
          // Acción rápida: añadir paciente (UI-only)
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Crear paciente (UI)')));
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kPersonnelPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: kPersonnelPrimaryColor.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_add, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Nuevo',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          // Search bar compacta
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Buscar por nombre o DNI',
                hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade500, fontSize: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Filtros rápidos (chips)
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 4, right: 4),
              children: [
                const SizedBox(width: 4),
                _filterChip('Todos', selected: _activeFilter == 'Todos'),
                const SizedBox(width: 8),
                _filterChip('Embarazadas',
                    selected: _activeFilter == 'Embarazadas'),
                const SizedBox(width: 8),
                _filterChip('Alto riesgo',
                    selected: _activeFilter == 'Alto riesgo'),
                const SizedBox(width: 8),
                _filterChip('Recientes',
                    selected: _activeFilter == 'Recientes'),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {required bool selected}) {
    return GestureDetector(
      onTap: () => _setFilter(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 36,
        decoration: BoxDecoration(
          color: selected ? kPersonnelPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: selected ? kPersonnelPrimaryColor : Colors.grey.shade200),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: kPersonnelPrimaryColor.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : Colors.grey.shade800,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListWithBloc() {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is AllPatientsLoaded) {
          // Actualiza los arrays y aplica filtro
          setState(() {
            _allPatients = state.patients;
            _filteredPatients = List.from(state.patients);
            _filterPatients();
          });
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      builder: (context, state) {
        if (state is PatientLoading && _allPatients.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_filteredPatients.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_alt_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No hay pacientes',
                    style: GoogleFonts.poppins(color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text('Intenta otro filtro o añade uno nuevo',
                    style: GoogleFonts.poppins(
                        color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          );
        }

        // Lista animada simple — animación por ítem con TweenAnimationBuilder
        return RefreshIndicator(
          onRefresh: () async {
            context.read<PatientBloc>().add(GetAllPatients());
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            itemCount: _filteredPatients.length,
            itemBuilder: (context, index) {
              final patient = _filteredPatients[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.96, end: 1),
                duration:
                    Duration(milliseconds: 220 + (index * 18).clamp(0, 260)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                      scale: value,
                      alignment: Alignment.topCenter,
                      child: child);
                },
                child: _PatientCardRich(patient: patient),
              );
            },
          ),
        );
      },
    );
  }
}

/// Card moderno y rico en detalles del paciente (sin depender de campos extras)
class _PatientCardRich extends StatelessWidget {
  final Patient patient;
  const _PatientCardRich({required this.patient});

  // Computa semanas de gestación si lastMenstrualPeriod está disponible
  int? _weeksOfGestation() {
    try {
      if (patient.lastMenstrualPeriod == null) return null;
      final now = DateTime.now();
      final diff = now.difference(patient.lastMenstrualPeriod);
      return (diff.inDays / 7).floor();
    } catch (_) {
      return null;
    }
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'alto':
        return Colors.red.shade700;
      case 'medio':
        return Colors.orange.shade800;
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weeks = _weeksOfGestation();
    final hasPregnancy = patient.estimatedDueDate != null || weeks != null;

    // Placeholder risk (puedes mapear de patient.riskLevel si existe)
    final riskLevel = 'Bajo';
    final riskColor = _riskColor(riskLevel);

    return Dismissible(
      key: ValueKey(patient.hashCode),
      background: Container(
        decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.archive, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        // UI-only: no elimina realmente
        if (dir == DismissDirection.endToStart) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Archivado (UI)')));
          return false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Marcado como atendido (UI)')));
          return false;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            // Navegar al detalle: placeholder
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Abrir detalle: ${patient.fullName} (UI)')));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Avatar + online badge
                Stack(
                  children: [
                    _buildAvatar(patient, size: 56),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.greenAccent.shade700
                                      .withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 12),
                // Info principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre + DNI + tag
                      Row(
                        children: [
                          Expanded(
                            child: Text(patient.fullName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: riskColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text('Riesgo: $riskLevel',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: riskColor,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // DNI / edad placeholder
                      Row(
                        children: [
                          Icon(Icons.badge_outlined,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text('DNI: ${patient.nationalId}',
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey.shade700),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Row con datos clínicos resumidos — ahora con Flexible para evitar overflow
                      Row(
                        children: [
                          if (hasPregnancy) ...[
                            Icon(Icons.pregnant_woman_outlined,
                                size: 14, color: Colors.pink.shade400),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                weeks != null
                                    ? '$weeks semanas'
                                    : 'FPP: ${_formatDate(patient.estimatedDueDate)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.grey.shade700),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Icon(Icons.calendar_today_outlined,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'FPP: ${patient.estimatedDueDate != null ? _formatDate(patient.estimatedDueDate) : "-"}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Acciones rápidas (icon buttons)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Llamar a ${patient.fullName} (UI)')));
                      },
                      icon: const Icon(Icons.phone,
                          size: 20, color: kPersonnelPrimaryColor),
                      splashRadius: 22,
                      tooltip: 'Llamar',
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Enviar mensaje a ${patient.fullName} (UI)')));
                      },
                      icon: const Icon(Icons.chat_bubble,
                          size: 20, color: Colors.grey),
                      splashRadius: 22,
                      tooltip: 'Mensaje',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Patient p, {double size = 48}) {
    // Usamos iniciales si no hay avatar en el modelo
    final initials = _initialsFromName(p.fullName);
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: kPersonnelPrimaryColor.withOpacity(0.12),
      child: Text(initials,
          style: GoogleFonts.poppins(
              color: kPersonnelPrimaryColor, fontWeight: FontWeight.bold)),
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    try {
      return DateFormat('dd/MM/yy').format(d);
    } catch (_) {
      return '-';
    }
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

// lib/presentation/screens/patient/gamification/pregnancy_timeline_screen.dart
import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class PregnancyTimelineScreen extends StatefulWidget {
  const PregnancyTimelineScreen({super.key});

  @override
  State<PregnancyTimelineScreen> createState() =>
      _PregnancyTimelineScreenState();
}

class _PregnancyTimelineScreenState extends State<PregnancyTimelineScreen> {
  @override
  void initState() {
    super.initState();
    // Aseguramos que los datos se carguen al iniciar la pantalla
    context.read<GamificationBloc>().add(const LoadPregnancyMilestones(
        patientId: 1)); // El ID del paciente debe ser dinámico en producción
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el tema definido en main.dart
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mi Embarazo'),
        leading: const BackButton(color: kTextColor),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          if (state is GamificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PregnancyMilestonesLoaded) {
            if (state.milestones.isEmpty) {
              return Center(
                child: Text(
                  'Aún no hay hitos disponibles.',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return _buildTimeline(state.milestones);
          }
          if (state is GamificationError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
            );
          }
          // Manejo de estado inicial
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTimeline(List<PregnancyMilestone> milestones) {
    // Ordenar por semana, por si acaso no vienen ordenados
    milestones.sort((a, b) => a.weekNumber.compareTo(b.weekNumber));

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
            child: SizedBox(height: 16)), // Espacio superior
        _buildHeader(milestones),
        _buildTimelineContent(milestones),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildHeader(List<PregnancyMilestone> milestones) {
    // <-- AHORA USAMOS DATOS REALES
    final completedMilestones = milestones.where((m) => m.isActive).length;
    final totalMilestones = milestones.length;
    final progress =
        totalMilestones > 0 ? completedMilestones / totalMilestones : 0.0;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // Usamos nuestro gradiente temático
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.flag_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu Viaje de Embarazo',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedMilestones de $totalMilestones hitos completados',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineContent(List<PregnancyMilestone> milestones) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Ordenamos de más reciente a más antiguo para la vista
          final milestone = milestones.reversed.toList()[index];
          final isLast = index == milestones.length - 1;

          // <-- LA LÓGICA DE SIMULACIÓN SE ELIMINA Y USAMOS EL DATO REAL
          return _buildTimelineItem(milestone, isLast,
              isCompleted: milestone.isActive);
        },
        childCount: milestones.length,
      ),
    );
  }

  Widget _buildTimelineItem(PregnancyMilestone milestone, bool isLast,
      {required bool isCompleted}) {
    // <-- `isCompleted` ahora es requerido
    final theme = Theme.of(context);
    final Color activeColor = Colors.green.shade400;
    final Color inactiveColor = Colors.grey.shade400;
    final Color circleColor = isCompleted ? activeColor : inactiveColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Línea de tiempo vertical
          Container(
            margin: const EdgeInsets.only(left: 25),
            width: 2,
            color: isLast ? Colors.transparent : Colors.grey.shade300,
          ),
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: theme.scaffoldBackgroundColor, width: 4),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ),
          // Contenido del hito
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 16, bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Semana ${milestone.weekNumber}',
                          style: GoogleFonts.poppins(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isCompleted)
                        Text(
                          '+${milestone.pointsReward} pts',
                          style: GoogleFonts.poppins(
                            color: activeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    milestone.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milestone.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const Divider(height: 24),
                  if (isCompleted) ...{
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: activeColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Completado',
                          style: GoogleFonts.poppins(
                            color: activeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  } else ...{
                    Row(
                      children: [
                        Icon(Icons.radio_button_unchecked,
                            color: inactiveColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Pendiente',
                          style: GoogleFonts.poppins(
                            color: inactiveColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

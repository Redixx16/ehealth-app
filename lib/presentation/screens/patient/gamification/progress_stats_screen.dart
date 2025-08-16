// lib/presentation/screens/patient/gamification/progress_stats_screen.dart
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kBackgroundColor = Color(0xFFFFF7F8);
const Color kTextColor = Color(0xFF424242);

class ProgressStatsScreen extends StatefulWidget {
  const ProgressStatsScreen({super.key});

  @override
  State<ProgressStatsScreen> createState() => _ProgressStatsScreenState();
}

class _ProgressStatsScreenState extends State<ProgressStatsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos todos los datos necesarios para esta pantalla
    context.read<GamificationBloc>().add(const LoadUserProgress(userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Tu Progreso'),
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          if (state is UserProgressLoaded) {
            return _buildStatsContent(state.progress);
          }
          if (state is GamificationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Muestra un indicador de carga para el estado inicial y de carga
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatsContent(UserProgress progress) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProgressOverview(progress),
        const SizedBox(height: 16),
        _buildLevelProgress(progress),
        const SizedBox(height: 16),
        _buildDetailedStats(progress),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProgressOverview(UserProgress progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
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
                child: const Icon(Icons.analytics_outlined,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen General',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nivel ${progress.level}',
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
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Puntos Totales',
                  '${progress.totalPoints}',
                  Icons.star_border_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Racha Actual',
                  '${progress.currentStreak} días',
                  Icons.local_fire_department_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress(UserProgress progress) {
    final progressPercentage = (progress.experiencePoints % 100) / 100;

    return Card(
      elevation: 2,
      shadowColor: kPrimaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso al Siguiente Nivel',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel ${progress.level}',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${progress.experiencePoints % 100} / 100 XP',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progressPercentage * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: kPrimaryLightColor.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(UserProgress progress) {
    return Card(
      elevation: 2,
      shadowColor: kPrimaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles de Actividad',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
            ),
            const Divider(height: 24),
            _buildDetailRow(
                'Citas Asistidas',
                '${progress.appointmentsAttended}',
                Icons.calendar_month_outlined,
                Colors.blue.shade300),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Controles de Salud',
                '${progress.healthCheckupsCompleted}',
                Icons.monitor_heart_outlined,
                Colors.green.shade300),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Módulos Educativos',
                '${progress.educationModulesCompleted}',
                Icons.school_outlined,
                Colors.purple.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 15, color: kTextColor),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold, color: kTextColor),
        ),
      ],
    );
  }
}

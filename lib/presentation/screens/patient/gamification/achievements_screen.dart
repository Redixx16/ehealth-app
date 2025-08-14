// lib/presentation/screens/patient/gamification/achievements_screen.dart
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta de colores consistente
const Color kPrimaryColor = Color(0xFFF48FB1);
const Color kPrimaryLightColor = Color(0xFFF8BBD0);
const Color kTextColor = Color(0xFF424242);

// ================== ESTRUCTURA CORREGIDA ==================
// Widget principal que provee el BLoC (si fuera necesario, pero ya lo hace main.dart)
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Este widget ahora solo se encarga de construir la vista interna.
    return const _AchievementsView();
  }
}

// Vista interna que maneja el estado y la UI
class _AchievementsView extends StatefulWidget {
  const _AchievementsView();

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}
// =========================================================

class _AchievementsViewState extends State<_AchievementsView> {
  @override
  void initState() {
    super.initState();
    // Siempre pedimos los logros al entrar a esta pantalla
    context.read<GamificationBloc>().add(const LoadAchievements(userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamificationBloc, GamificationState>(
      builder: (context, state) {
        if (state is AchievementsLoaded) {
          if (state.achievements.isEmpty) {
            return Center(
              child: Text(
                'No hay logros disponibles.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return _buildAchievementsList(state.achievements);
        }

        if (state is GamificationError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
            ),
          );
        }

        // Para cualquier otro estado (Initial, Loading, o uno inesperado), mostramos el spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    // Simulación de logros bloqueados y desbloqueados para visualización
    final unlockedAchievements =
        achievements.where((a) => a.id.isEven).toList();
    final lockedAchievements = achievements.where((a) => a.id.isOdd).toList();

    return CustomScrollView(
      slivers: [
        _buildStatsHeader(unlockedAchievements.length, achievements.length),
        _buildSectionHeader(
            'Logros Desbloqueados', Icons.emoji_events, kPrimaryColor),
        _buildAchievementsGrid(unlockedAchievements, true),
        _buildSectionHeader(
            'Logros Pendientes', Icons.lock_outline, Colors.grey.shade600),
        _buildAchievementsGrid(lockedAchievements, false),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildStatsHeader(int unlocked, int total) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$unlocked de $total',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logros Completados',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsGrid(
      List<Achievement> achievements, bool isUnlocked) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              _buildAchievementCard(achievements[index], isUnlocked),
          childCount: achievements.length,
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    final Color activeColor = kPrimaryColor.withOpacity(0.8);
    final Color inactiveColor = Colors.grey.shade400;

    return Container(
      decoration: BoxDecoration(
        color:
            isUnlocked ? Colors.white : Colors.grey.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: isUnlocked
            ? Border.all(color: kPrimaryLightColor, width: 2)
            : Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? kPrimaryLightColor.withOpacity(0.3)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                color: isUnlocked ? activeColor : inactiveColor,
                size: 32,
              ),
            ),
            const Spacer(),
            Text(
              achievement.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isUnlocked ? kTextColor : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? activeColor.withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${achievement.pointsReward} pts',
                style: GoogleFonts.poppins(
                  color: isUnlocked ? activeColor : inactiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

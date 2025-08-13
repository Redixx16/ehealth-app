import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/presentation/bloc/gamification/gamification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GamificationBloc>().add(const LoadAchievements(userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      child: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          if (state is AchievementsLoaded) {
            return _buildAchievementsList(state.achievements);
          } else if (state is GamificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text('No se pudieron cargar los logros'),
            );
          }
        },
      ),
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    final unlockedAchievements = achievements.where((a) => a.isActive).toList();
    final lockedAchievements = achievements.where((a) => !a.isActive).toList();

    return CustomScrollView(
      slivers: [
        _buildStatsHeader(unlockedAchievements.length, achievements.length),
        _buildSectionHeader('Logros Desbloqueados', Icons.emoji_events, Colors.amber),
        _buildAchievementsGrid(unlockedAchievements, true),
        _buildSectionHeader('Logros Pendientes', Icons.lock, Colors.grey),
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
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                    '$unlocked/$total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Logros Completados',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
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
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
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

  Widget _buildAchievementsGrid(List<Achievement> achievements, bool isUnlocked) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildAchievementCard(achievements[index], isUnlocked),
          childCount: achievements.length,
        ),
      ),
    );
  }

Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
  return Container(
    decoration: BoxDecoration(
      color: isUnlocked ? Colors.white : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      boxShadow: isUnlocked
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      border: isUnlocked
          ? Border.all(color: Colors.amber.shade200, width: 2)
          : Border.all(color: Colors.grey.shade300),
    ),
    child: Stack(
      children: [
        if (!isUnlocked)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          // Wrap the Column with a SingleChildScrollView
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.amber.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: isUnlocked ? Colors.amber.shade700 : Colors.grey.shade500,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  achievement.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isUnlocked ? Colors.black87 : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Consider increasing maxLines or removing it
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.amber.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${achievement.pointsReward} pts',
                    style: TextStyle(
                      color: isUnlocked ? Colors.amber.shade700 : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
} 
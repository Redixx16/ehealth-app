// lib/presentation/bloc/gamification/gamification_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/domain/usecases/gamification/add_points.dart';
import 'package:ehealth_app/domain/usecases/gamification/check_and_award_achievements.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_achievements.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_pregnancy_milestones.dart';
import 'package:ehealth_app/domain/usecases/gamification/get_user_progress.dart';
import 'package:ehealth_app/domain/usecases/gamification/increment_appointment_attendance.dart';
import 'package:equatable/equatable.dart';

part 'gamification_event.dart';
part 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final GetUserProgressUseCase getUserProgressUseCase;
  final GetAchievementsUseCase getAchievementsUseCase;
  final GetPregnancyMilestonesUseCase getPregnancyMilestonesUseCase;
  final IncrementAppointmentAttendanceUseCase
      incrementAppointmentAttendanceUseCase;
  final CheckAndAwardAchievementsUseCase checkAndAwardAchievementsUseCase;
  final AddPointsUseCase addPointsUseCase;

  GamificationBloc({
    required this.getUserProgressUseCase,
    required this.getAchievementsUseCase,
    required this.getPregnancyMilestonesUseCase,
    required this.incrementAppointmentAttendanceUseCase,
    required this.checkAndAwardAchievementsUseCase,
    required this.addPointsUseCase,
  }) : super(GamificationInitial()) {
    on<LoadUserProgress>(_onLoadUserProgress);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadPregnancyMilestones>(_onLoadPregnancyMilestones);
    on<MarkAppointmentAttended>(_onMarkAppointmentAttended);
    on<MarkMilestoneCompleted>(_onMarkMilestoneCompleted);
    on<CheckIn>(_onCheckIn);
    on<UnlockAchievement>(_onUnlockAchievement);
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<GamificationState> emit,
  ) async {
    print("🔷 GAMIFICATION_BLOC: Recibido evento LoadAchievements.");
    emit(GamificationLoading());
    try {
      print("🔷 GAMIFICATION_BLOC: Llamando a getAchievementsUseCase...");
      final achievements = await getAchievementsUseCase.execute();
      print(
          "🔷 GAMIFICATION_BLOC: getAchievementsUseCase completado. Logros: ${achievements.length}");
      emit(AchievementsLoaded(achievements));
    } catch (e) {
      print("❌ GAMIFICATION_BLOC: Error al cargar logros: $e");
      emit(GamificationError(e.toString()));
    }
  }

  // ... (El resto de los métodos se mantienen igual)

  Future<void> _onLoadUserProgress(
    LoadUserProgress event,
    Emitter<GamificationState> emit,
  ) async {
    emit(GamificationLoading());
    try {
      final progress = await getUserProgressUseCase.execute();
      emit(UserProgressLoaded(progress));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onLoadPregnancyMilestones(
    LoadPregnancyMilestones event,
    Emitter<GamificationState> emit,
  ) async {
    emit(GamificationLoading());
    try {
      final milestones = await getPregnancyMilestonesUseCase.execute();
      emit(PregnancyMilestonesLoaded(milestones));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onMarkAppointmentAttended(
    MarkAppointmentAttended event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      await incrementAppointmentAttendanceUseCase.execute();
      await checkAndAwardAchievementsUseCase.execute();
      add(LoadUserProgress(userId: event.userId));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onMarkMilestoneCompleted(
    MarkMilestoneCompleted event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      await addPointsUseCase.execute(event.pointsReward);
      await checkAndAwardAchievementsUseCase.execute();
      add(LoadUserProgress(userId: event.userId));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onCheckIn(
    CheckIn event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      await addPointsUseCase.execute(10);
      await checkAndAwardAchievementsUseCase.execute();
      add(LoadUserProgress(userId: event.userId));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievement event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      await addPointsUseCase.execute(event.pointsReward);
      add(LoadUserProgress(userId: event.userId));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }
}

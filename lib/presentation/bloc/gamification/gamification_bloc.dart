// lib/presentation/bloc/gamification/gamification_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:ehealth_app/domain/entities/achievement.dart';
import 'package:ehealth_app/domain/entities/user_progress.dart';
import 'package:ehealth_app/domain/entities/pregnancy_milestone.dart';
import 'package:ehealth_app/domain/repositories/gamification_repository.dart';
import 'package:equatable/equatable.dart';

part 'gamification_event.dart';
part 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final GamificationRepository gamificationRepository;

  GamificationBloc({required this.gamificationRepository})
      : super(GamificationInitial()) {
    on<LoadUserProgress>(_onLoadUserProgress);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadPregnancyMilestones>(_onLoadPregnancyMilestones);
    on<MarkAppointmentAttended>(_onMarkAppointmentAttended);
    on<MarkMilestoneCompleted>(_onMarkMilestoneCompleted);
    on<CheckIn>(_onCheckIn);
    on<UnlockAchievement>(_onUnlockAchievement);
  }

  Future<void> _onLoadUserProgress(
    LoadUserProgress event,
    Emitter<GamificationState> emit,
  ) async {
    emit(GamificationLoading());
    try {
      final progress = await gamificationRepository.getUserProgress();
      emit(UserProgressLoaded(progress));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<GamificationState> emit,
  ) async {
    // ================== CORRECCIÓN CLAVE ==================
    // Emitimos el estado de carga ANTES de la llamada a la API.
    emit(GamificationLoading());
    // ======================================================
    try {
      final achievements = await gamificationRepository.getAchievements();
      emit(AchievementsLoaded(achievements));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }

  Future<void> _onLoadPregnancyMilestones(
    LoadPregnancyMilestones event,
    Emitter<GamificationState> emit,
  ) async {
    // También aplicamos la misma corrección aquí para consistencia
    emit(GamificationLoading());
    try {
      final milestones = await gamificationRepository.getPregnancyMilestones();
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
      await gamificationRepository.incrementAppointmentAttendance();
      await gamificationRepository.checkAndAwardAchievements();
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
      await gamificationRepository.addPoints(event.pointsReward);
      await gamificationRepository.checkAndAwardAchievements();
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
      await gamificationRepository.addPoints(10);
      await gamificationRepository.checkAndAwardAchievements();
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
      await gamificationRepository.addPoints(event.pointsReward);
      add(LoadUserProgress(userId: event.userId));
    } catch (e) {
      emit(GamificationError(e.toString()));
    }
  }
}

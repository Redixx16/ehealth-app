// lib/presentation/screens/personnel/personnel_dashboard_screen.dart
import 'dart:async';

import 'package:ehealth_app/domain/entities/appointment.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_bloc.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_event.dart';
import 'package:ehealth_app/presentation/bloc/appointments/appointments_state.dart';
import 'package:ehealth_app/presentation/screens/appointments/appointment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ehealth_app/injection_container.dart' as di;

/// Filtros disponibles del dashboard
enum _DashFilter { todos, hoy, proximos7, pasadas }

/// Dashboard del personal — versión estática (placeholders) para evitar dependencias de modelo.
class PersonnelDashboardScreen extends StatefulWidget {
  const PersonnelDashboardScreen({super.key});

  @override
  State<PersonnelDashboardScreen> createState() =>
      _PersonnelDashboardScreenState();
}

class _PersonnelDashboardScreenState extends State<PersonnelDashboardScreen>
    with SingleTickerProviderStateMixin {
  _DashFilter _selected = _DashFilter.hoy;
  late final PageController _pageController;
  late final AnimationController _fadeController;
  Timer? _autoScrollTimer;

  // intervalo de autoscroll
  static const Duration _autoScrollInterval = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.86);
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_autoScrollInterval, (_) {
      if (!_pageController.hasClients) return;
      const pageCount = 3; // slides: Hoy, Próximos 7, Pasadas
      final current =
          (_pageController.page ?? _pageController.initialPage).round();
      final next = (current + 1) % pageCount;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void _pauseAutoScrollWhileUserInteracting() {
    _autoScrollTimer?.cancel();
    Future.delayed(const Duration(seconds: 4), _startAutoScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.locator<AppointmentsBloc>()..add(FetchAppointments()),
      child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AppointmentsBloc>().add(FetchAppointments());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                _buildAnimatedTitle(context),
                _buildCarouselSummary(context, state),
                _buildFilterBar(context),
                _buildAppointments(context, state),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 28)),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _buildAnimatedTitle(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Row(
            children: [
              Text('Tu agenda',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(
                DateFormat('EEE d MMM', 'es_ES').format(DateTime.now()),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCarouselSummary(
      BuildContext context, AppointmentsState state) {
    final theme = Theme.of(context);

    int countHoy = 0;
    int countProx = 0;
    int countPasadas = 0;

    if (state is AppointmentsLoadSuccess) {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final next7 = now.add(const Duration(days: 7));

      for (final a in state.appointments) {
        final d = a.appointmentDate.toLocal();
        if (d.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            d.isBefore(todayEnd.add(const Duration(seconds: 1)))) {
          countHoy++;
        } else if (d.isAfter(now) && d.isBefore(next7)) {
          countProx++;
        } else if (d.isBefore(now)) {
          countPasadas++;
        }
      }
    }

    final slides = [
      _AutoSummarySlide(
          title: "Hoy",
          count: countHoy,
          color: theme.primaryColor,
          icon: Icons.today_rounded),
      _AutoSummarySlide(
          title: "Próximos 7 días",
          count: countProx,
          color: Colors.orange.shade700,
          icon: Icons.calendar_month_rounded),
      _AutoSummarySlide(
          title: "Pasadas",
          count: countPasadas,
          color: Colors.pink.shade600,
          icon: Icons.history_rounded),
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 150,
        child: NotificationListener<UserScrollNotification>(
          onNotification: (n) {
            // Pausamos autoscroll siempre que el usuario interactúa
            _pauseAutoScrollWhileUserInteracting();
            return false;
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            padEnds: false,
            itemBuilder: (_, i) => AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double t = 0;
                if (_pageController.position.haveDimensions) {
                  t = (_pageController.page ?? _pageController.initialPage)
                          .toDouble() -
                      i;
                }
                t = (1 - (t.abs() * 0.18)).clamp(0.9, 1.0);
                return Transform.scale(scale: t, child: child);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: i == 0 ? 20 : 12,
                    right: i == slides.length - 1 ? 20 : 12),
                child: slides[i],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFilterBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              SegmentBtn(
                  label: 'Todos',
                  selected: _selected == _DashFilter.todos,
                  onTap: () => _setFilter(_DashFilter.todos)),
              SegmentBtn(
                  label: 'Hoy',
                  selected: _selected == _DashFilter.hoy,
                  onTap: () => _setFilter(_DashFilter.hoy)),
              SegmentBtn(
                  label: 'Próx. 7d',
                  selected: _selected == _DashFilter.proximos7,
                  onTap: () => _setFilter(_DashFilter.proximos7)),
              SegmentBtn(
                  label: 'Pasadas',
                  selected: _selected == _DashFilter.pasadas,
                  onTap: () => _setFilter(_DashFilter.pasadas)),
            ],
          ),
        ),
      ),
    );
  }

  void _setFilter(_DashFilter f) {
    if (_selected != f) {
      setState(() {
        _selected = f;
      });
    }
  }

  Widget _buildAppointments(BuildContext context, AppointmentsState state) {
    if (state is AppointmentsLoadFailure) {
      return _buildError(state.error);
    }
    if (state is! AppointmentsLoadSuccess) {
      return _buildLoading();
    }

    final filtered = _filterAppointments(state.appointments, _selected);
    if (filtered.isEmpty) {
      return _buildEmpty("No hay citas para este filtro.");
    }

    filtered.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final appt = filtered[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.98, end: 1),
              duration:
                  Duration(milliseconds: 220 + (index * 16).clamp(0, 240)),
              curve: Curves.easeOut,
              builder: (_, value, child) => Transform.scale(
                  scale: value, alignment: Alignment.topCenter, child: child),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DetailedAppointmentCardStatic(appointment: appt),
              ),
            );
          },
          childCount: filtered.length,
        ),
      ),
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> all, _DashFilter f) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final next7 = now.add(const Duration(days: 7));

    switch (f) {
      case _DashFilter.todos:
        return List.of(all);
      case _DashFilter.hoy:
        return all.where((a) {
          final d = a.appointmentDate.toLocal();
          return d.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
              d.isBefore(todayEnd.add(const Duration(seconds: 1)));
        }).toList();
      case _DashFilter.proximos7:
        return all.where((a) {
          final d = a.appointmentDate.toLocal();
          return d.isAfter(now) && d.isBefore(next7);
        }).toList();
      case _DashFilter.pasadas:
        return all
            .where((a) => a.appointmentDate.toLocal().isBefore(now))
            .toList();
    }
  }

  // ---------- Helpers loading / empty / error ----------

  SliverToBoxAdapter _buildLoading() => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );

  SliverToBoxAdapter _buildEmpty(String message) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(message, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
      );

  SliverToBoxAdapter _buildError(String error) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(child: Text('Error: $error')),
        ),
      );
}

// ===================================================================
// Widgets auxiliares (estáticos)
// ===================================================================

class _AutoSummarySlide extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _AutoSummarySlide(
      {required this.title,
      required this.count,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 0, maxWidth: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [color.withOpacity(0.16), color.withOpacity(0.04)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count',
                      style: theme.textTheme.headlineMedium?.copyWith(
                          color: color, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.grey.shade800)),
                  const SizedBox(height: 8),
                  // Barra de progreso/mini-descriptor (UI)
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (count.clamp(0, 20) / 20).toDouble(),
                          color: color,
                          backgroundColor: color.withOpacity(0.12),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('$count',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card detallado (ESTÁTICO: usa placeholders si no hay campos adicionales)
class _DetailedAppointmentCardStatic extends StatelessWidget {
  final Appointment appointment;
  const _DetailedAppointmentCardStatic({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = appointment.appointmentDate.toLocal();
    final hour = DateFormat('hh:mm a', 'es_ES').format(d);
    final day = DateFormat('EEE d MMM', 'es_ES').format(d);
    final now = DateTime.now();

    final isPast = d.isBefore(now);
    final Color accent = isPast ? Colors.grey.shade400 : theme.primaryColor;

    // Solo usamos fullName del paciente (si existe). Resto: placeholders estáticos.
    final patientName = appointment.patient?.fullName ?? 'Paciente no asignado';
    final initials = _initialsFromName(patientName);

    // Placeholders para datos opcionales (estáticos por ahora)
    const String placeholderAgeGender = '—';
    const String placeholderReason = 'Sin motivo registrado';
    const String placeholderPriority = ''; // vacío si no hay prioridad

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AppointmentDetailScreen(
                  appointment: appointment, showEditButton: true)),
        );
        if (result == true && context.mounted) {
          context.read<AppointmentsBloc>().add(FetchAppointments());
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 110,
                  decoration: BoxDecoration(
                      color: accent,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14))),
                ),
                const SizedBox(width: 12),
                // Avatar estático (iniciales)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: CircleAvatar(
                      radius: 26,
                      backgroundColor: accent.withOpacity(0.14),
                      child: Text(initials,
                          style: TextStyle(
                              color: accent, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 12),
                // Info principal
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre + placeholder edad/género
                        Row(
                          children: [
                            Expanded(
                              child: Text(patientName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(placeholderAgeGender,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Motivo (placeholder)
                        Text(placeholderReason,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey.shade700)),
                        const SizedBox(height: 12),
                        // Fecha/hora + acciones UI — corregido para evitar overflow
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 16, color: Colors.grey.shade500),
                            const SizedBox(width: 6),
                            // Un solo texto expandible que contiene día y hora, para evitar overflow
                            Expanded(
                              child: Text(
                                '$day • $hour',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Botones de acción (toman espacio mínimo)
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Llamar (UI)')));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(Icons.phone,
                                      size: 18, color: Colors.grey.shade600)),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Mensaje (UI)')));
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(Icons.chat,
                                      size: 18, color: Colors.grey.shade600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Pie con tags estáticos
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14))),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: isPast
                            ? Colors.grey.shade200
                            : accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18)),
                    child: Text(isPast ? 'Pasada' : 'Programada',
                        style: TextStyle(
                            color: isPast ? Colors.grey.shade700 : accent,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 8),
                  if (placeholderPriority.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(18)),
                      child: const Text(placeholderPriority,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700)),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AppointmentDetailScreen(
                                appointment: appointment,
                                showEditButton: true)),
                      );
                      if (result == true && context.mounted) {
                        context
                            .read<AppointmentsBloc>()
                            .add(FetchAppointments());
                      }
                    },
                    style: TextButton.styleFrom(
                        minimumSize: const Size(36, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12)),
                    child: const Text('Ver',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

// -------------------------------------------------------------------
// Botón de segmento (pill) — sin overflow, adaptable
// -------------------------------------------------------------------
class SegmentBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SegmentBtn(
      {required this.label,
      required this.selected,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? theme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: selected ? theme.primaryColor : Colors.grey.shade200),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.grey.shade800,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

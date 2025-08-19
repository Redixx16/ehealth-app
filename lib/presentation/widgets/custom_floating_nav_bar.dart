// lib/presentation/widgets/custom_floating_nav_bar.dart
import 'package:flutter/material.dart';

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onCtaTapped;

  const CustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onCtaTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Contenedor principal de la barra de navegación
        Container(
          height: 65 + safeAreaBottom,
          margin: EdgeInsets.fromLTRB(24, 0, 24, safeAreaBottom > 0 ? 0 : 24),
          padding: EdgeInsets.only(bottom: safeAreaBottom),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.5),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_filled, 'Inicio', 0),
              _buildNavItem(context, Icons.calendar_month, 'Citas', 1),
              const SizedBox(width: 56), // Espacio para el botón central
              _buildNavItem(context, Icons.school, 'Educación', 2),
              _buildNavItem(context, Icons.person, 'Perfil', 3),
            ],
          ),
        ),
        // Botón de acción central (CTA)
        Positioned(
          bottom: (safeAreaBottom > 0 ? safeAreaBottom - 10 : 14),
          child: GestureDetector(
            onTap: onCtaTapped,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.favorite_border,
                  color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Clase auxiliar para cada item
class CustomNavBarItem {
  final IconData icon;
  final String label;

  CustomNavBarItem({required this.icon, required this.label});
}

class CustomFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onCtaTapped;
  final List<CustomNavBarItem> items;

  const CustomFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onCtaTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    final int leftCount = items.length ~/ 2;
    final int rightCount = items.length - leftCount;

    final List<Widget> leftWidgets = List.generate(leftCount, (i) {
      final int idx = i;
      return _buildNavItem(context, items[idx], idx);
    });

    final List<Widget> rightWidgets = List.generate(rightCount, (i) {
      final int idx = i + leftCount;
      return _buildNavItem(context, items[idx], idx);
    });

    const double ctaDiameter = 64.0;
    const double navHeight = 64.0;
    const double containerHeight = navHeight + 16.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: containerHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Barra de navegación
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: navHeight,
              padding: EdgeInsets.only(
                  bottom: safeAreaBottom > 0 ? safeAreaBottom : 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(navHeight / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: Row(children: leftWidgets)),
                  const SizedBox(width: ctaDiameter * 0.95),
                  Expanded(child: Row(children: rightWidgets)),
                ],
              ),
            ),
          ),
          // Botón central (corazón rosado con brillo ✨)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onCtaTapped,
              child: Container(
                width: ctaDiameter,
                height: ctaDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF80AB),
                      Color(0xFFF50057)
                    ], // rosa claro → rosa fuerte
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                    // Un brillo extra como halo
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite, // corazón ♥
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, CustomNavBarItem item, int index) {
    final bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

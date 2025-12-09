import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';

class StreetNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const StreetNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margen para que "flote" sobre el fondo
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Gris oscuro de fondo
        border: Border.all(color: Colors.black, width: 3), // Borde grueso
        // Sombra sólida desplazada
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_filled, "INICIO"),
          _buildNavItem(1, Icons.map, "MAPA"),
          _buildNavItem(2, Icons.person, "PERFIL"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Si está seleccionado, fondo NEÓN. Si no, transparente.
          color: isSelected ? kNeonGreen : Colors.transparent,
          // Borde sutil solo si está seleccionado
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              // Si está seleccionado, ícono negro (contraste con neón). Si no, blanco.
              color: isSelected ? Colors.black : Colors.white,
              size: 28,
            ),
            // Opcional: Mostrar texto solo si está seleccionado (Efecto expandible)
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
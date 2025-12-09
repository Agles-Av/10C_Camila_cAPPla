import 'package:cappla/features/shared/widget/street_widgets.dart'; // Importa tus colores
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AlertType { success, error, info }

class StreetAlerts {
  
  static void show(BuildContext context, String message, AlertType type) {
    // Definimos colores e iconos según el tipo
    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case AlertType.success:
        bgColor = kNeonGreen;
        borderColor = Colors.black;
        textColor = Colors.black;
        icon = Icons.check_circle_outline;
        break;
      case AlertType.error:
        bgColor = kNeonPink;
        borderColor = Colors.black;
        textColor = Colors.black;
        icon = Icons.error_outline;
        break;
      case AlertType.info:
        bgColor = kAsphalt;
        borderColor = kNeonGreen;
        textColor = Colors.white;
        icon = Icons.info_outline;
        break;
    }

    // Ocultamos alertas previas para que no se acumulen
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating, // Flota sobre el contenido
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 3), // Borde grueso
            // Sombra dura desplazada (Efecto Sticker)
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      type == AlertType.error ? "ERROR" : (type == AlertType.success ? "ÉXITO" : "INFO"),
                      style: GoogleFonts.anton(
                        color: textColor,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.toUpperCase(), // Todo en mayúsculas se ve más "rudo"
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
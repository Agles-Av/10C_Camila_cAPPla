import 'package:cappla/features/shared/widget/street_widgets.dart'; // Tus colores
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorState with ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void showErrorDialog(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false, // Obliga a tocar el botón
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent, // Transparente para dibujar nosotros
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kAsphalt,
                border: Border.all(color: kNeonPink, width: 3), // Borde rojo neón
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(8, 8), // Sombra muy pronunciada
                    blurRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícono gigante de advertencia
                  const Icon(Icons.warning_amber_rounded, color: kNeonPink, size: 60),
                  const SizedBox(height: 10),
                  
                  Text(
                    "SYSTEM ERROR",
                    style: GoogleFonts.anton(
                      color: kNeonPink,
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Text(
                    _errorMessage.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Botón personalizado
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kNeonPink,
                        shape: const BeveledRectangleBorder(), // Cuadrado
                        elevation: 0,
                      ),
                      child: Text(
                        "ENTENDIDO",
                        style: GoogleFonts.anton(color: Colors.black, letterSpacing: 1),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        clearError();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
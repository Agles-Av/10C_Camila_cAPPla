import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// COLORES GLOBALES
const Color kAsphalt = Color(0xFF121212); // Fondo oscuro
const Color kNeonGreen = Color(0xFF00FF88); // Acento principal
const Color kNeonPink = Color(0xFFFF0055); // Acento secundario (Likes/Errores)
const Color kConcrete = Color(0xFF2A2A2A); // Gris para tarjetas

// 1. TARJETA URBANA (Borde duro + Sombra sólida)
class StreetCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;

  const StreetCard({
    super.key,
    required this.child,
    this.borderColor,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: kConcrete,
        border: Border.all(color: borderColor ?? Colors.black, width: 2),
        // Sombra sólida desplazada (Efecto Sticker/Pared)
        boxShadow: [
          BoxShadow(
            color: borderColor != null ? borderColor!.withOpacity(0.5) : Colors.black,
            offset: const Offset(4, 4),
            blurRadius: 0, // Cero blur = Sombra dura
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

// 2. BOTÓN DE SPRAY (Botón principal)
class StreetButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;

  const StreetButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = kNeonGreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : color,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: isLoading
            ? const SizedBox(
                height: 20, width: 20, 
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
              )
            : Text(
                text.toUpperCase(),
                style: GoogleFonts.anton( // Fuente gruesa
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}

// 3. INPUT CALLEJERO (TextField)
class StreetInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const StreetInput({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: kNeonGreen),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: kAsphalt,
        // Bordes duros siempre
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.zero, // Cuadrado
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kNeonGreen, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kNeonPink, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kNeonPink, width: 2),
          borderRadius: BorderRadius.zero,
        ),
      ),

    );
  }
}
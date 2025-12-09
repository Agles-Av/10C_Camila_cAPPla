import 'package:cappla/core/utils/street_alerts.dart'; // Tus alertas tuneadas
import 'package:cappla/features/auth/data/models/login_dto.dart';
import 'package:cappla/features/auth/data/models/register_dto.dart';
import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart'; // Tus widgets callejeros
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();

    final dto = RegisterDto(
      nombre: _nameController.text.trim(),
      email: _emailController.text.trim(),
      contrasena: _passwordController.text,
      status: true,
    );

    try {
      final success = await provider.register(dto);

      if (success && mounted) {
        // ALERTA TUNEADA
        StreetAlerts.show(
          context,
          "Bienvenido al crew, inicia sesión",
          AlertType.success,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // ALERTA TUNEADA
        StreetAlerts.show(
          context,
          "Error al registrar. Intenta otro correo.",
          AlertType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      // AppBar transparente para que se vea el fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kNeonGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // TÍTULO GRAFFITI
                Text(
                  'NUEVO USUARIO',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 35,
                    color: kNeonGreen,
                    shadows: [
                      const Shadow(
                        color: kNeonPink,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Únete al arte urbano",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // ----- NOMBRE -----
                StreetInput(
                  controller: _nameController,
                  label: 'Tag / Nombre',
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Falta tu nombre' : null,
                ),
                const SizedBox(height: 20),

                // ----- EMAIL -----
                StreetInput(
                  controller: _emailController,
                  label: 'Correo',
                  icon: Icons.alternate_email,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Falta el correo';
                    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(value)) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ----- CONTRASEÑA (Manual para tener el botón de ver/ocultar) -----
                // Usamos el estilo del StreetInput pero lo construimos aquí para el suffixIcon
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock_outline, color: kNeonGreen),
                    filled: true,
                    fillColor: kAsphalt,
                    // Borde estilo StreetInput
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.zero,
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
                    // Icono Ojo
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ----- CONFIRMAR CONTRASEÑA -----
                StreetInput(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  icon: Icons.lock_reset,
                  isPassword: true, // Aquí no ponemos el ojo para no saturar
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // ----- BOTÓN REGISTRO -----
                StreetButton(
                  text: "UNIRSE AL CREW", // Texto con más actitud
                  isLoading: provider.isLoading,
                  onPressed: _submit,
                  color: kNeonGreen,
                ),
                
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "¿Ya tienes cuenta? Entra aquí",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
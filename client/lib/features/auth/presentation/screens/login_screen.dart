import 'package:cappla/core/utils/street_alerts.dart';
import 'package:cappla/features/auth/data/models/login_dto.dart';
import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/shared/widget/street_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();
    final dto = LoginDto(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      await provider.login(dto);

      if (provider.isLogged) {
        // Navigate to home or root. Adjust route as needed.
        Navigator.pushReplacementNamed(context, '/navigation');
      } else {
        StreetAlerts.show(context, "Credenciales inválidas", AlertType.error);
      }
    } catch (e) {
      StreetAlerts.show(
        context,
        "Revise sus credenciales y vuelva a intentarlo",
        AlertType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CAPPLA',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 45,
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
                const Text(
                  "Arte callejero, Kyu",
                  style: TextStyle(color: Colors.grey, letterSpacing: 2),
                ),

                const SizedBox(height: 40),

                StreetInput(
                  controller: _emailController,
                  label: 'Correo',
                  icon: Icons.alternate_email,
                  validator: (v) => v!.isEmpty ? "Falta el correo" : null,
                ),

                const SizedBox(height: 20),

                // --- INPUT CONTRASEÑA ACTUALIZADO ---
                StreetInput(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock_outline,

                  // 1. Conectamos la variable de estado
                  isPassword: _obscurePassword,

                  // 2. Pasamos el botón del ojo como suffixIcon
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey, // Color gris para no distraer
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  validator: (v) =>
                      v!.length < 6 ? "Mínimo 6 caracteres" : null,
                ),

                // ------------------------------------
                const SizedBox(height: 35),

                // ----- LOGIN BUTTON -----
                StreetButton(
                  text: "ENTRAR AHORA",
                  isLoading: provider.isLoading,
                  onPressed: () => _submit(context),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Regístrate aquí'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

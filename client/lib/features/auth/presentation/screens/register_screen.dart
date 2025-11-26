import 'package:cappla/features/auth/data/models/register_dto.dart';
import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
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

    // Creamos el DTO basado en lo que pide Java
    final dto = RegisterDto(
      nombre: _nameController.text.trim(),
      email: _emailController.text.trim(),
      contrasena: _passwordController.text,
      status: true,
    );

    try {
      final success = await provider.register(dto);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada exitosamente. Inicia sesión.'),
          ),
        );
        // Regresamos al Login para que ingrese sus credenciales
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error al registrar usuario. Intenta con otro correo.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Cuenta")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Registro',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // ----- NOMBRE -----
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Ingresa tu nombre'
                      : null,
                ),
                const SizedBox(height: 20),

                // ----- EMAIL -----
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa tu correo';
                    if (!RegExp(
                      r"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                    ).hasMatch(value)) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ----- CONTRASEÑA -----
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa una contraseña';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ----- CONFIRMAR CONTRASEÑA -----
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 35),

                // ----- BOTÓN REGISTRO -----
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Registrarme'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

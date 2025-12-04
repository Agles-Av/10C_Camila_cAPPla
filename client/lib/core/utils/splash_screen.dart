import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // 1. Simular tiempo de carga visual (opcional, pero se ve bien)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 2. Intentar cargar sesión guardada
    final authProvider = context.read<AuthProvider>();
    await authProvider.loadSession();

    if (!mounted) return;

    // 3. Decidir ruta
    if (authProvider.isLogged) {
      Navigator.pushReplacementNamed(context, '/navigation');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(35, 133, 0, 1),
              Color.fromRGBO(203, 204, 212, 1),
              Color.fromRGBO(69, 11, 184, 1),
            ],
            stops: [0.04, 0.49, 1.0],
          ),
        ),
        child: Center(
          // Asegúrate que la imagen existe, si no usa un Icon para probar
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 300, height: 200),
              const Icon(
                Icons.flutter_dash,
                size: 100,
                color: Colors.white,
              ), // Placeholder seguro
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

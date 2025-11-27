import 'package:cappla/core/config/dio_client.dart';
import 'package:cappla/core/config/error_state.dart';
import 'package:cappla/features/auth/data/services/auth_service.dart';
import 'package:cappla/features/auth/presentation/provider/auth_provider.dart';
import 'package:cappla/features/auth/presentation/screens/login_screen.dart';
import 'package:cappla/features/auth/presentation/screens/register_screen.dart';
import 'package:cappla/features/publication/data/service/home_service.dart';
import 'package:cappla/features/publication/presentation/provider/home_provider.dart';
import 'package:cappla/features/publication/presentation/screens/home_screen.dart';
import 'package:cappla/features/shared/providers/navigation_provider.dart';
import 'package:cappla/routes/navigation.dart';
import 'package:cappla/core/utils/splash_screen.dart'; // Asegúrate de importar esto
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importante
import 'package:provider/provider.dart';

// Hacemos el main asíncrono para cargar el .env
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Requerido si el main es async
  await dotenv.load(fileName: ".env"); // Carga las variables
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ErrorState()),
        Provider(create: (_) => DioClient()),
        ProxyProvider<DioClient, AuthService>(
          update: (_, dio, __) => AuthService(dio),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (_) => AuthProvider(),
          update: (_, service, provider) => provider!..update(service),
        ),
        ProxyProvider<DioClient, HomeService>(
          update: (_, dio, __) => HomeService(dio),
        ),
        ChangeNotifierProxyProvider<HomeService, HomeProvider>(
          create: (_) => HomeProvider(),
          update: (_, service, provider) => provider!..update(service),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cappla',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/navigation': (context) => const Navigation(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

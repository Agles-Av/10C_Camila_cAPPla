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
import 'package:cappla/core/utils/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// 1. INSTANCIA GLOBAL (Fuera del main)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 2. CANAL GLOBAL (Fuera del main)
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'Notificaciones Importantes', // title
  description: 'Este canal se usa para notificaciones importantes.',
  importance: Importance.max,
);

// 3. HANDLER DE FONDO (Opcional, pero recomendado para evitar errores)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensaje en segundo plano: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  // Configurar handler de fondo
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. CONFIGURAR NOTIFICACIONES LOCALES (Todo en el mismo nivel)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Nota: Si usas iOS, aquí deberías agregar la config de iOS, pero como es cuenta gratis, lo dejamos así
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 5. CREAR EL CANAL EN ANDROID
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // 6. CONFIGURAR FIREBASE
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFF00FF88),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.permanentMarker(
              fontSize: 24,
              color: const Color(0xFF00FF88),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
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
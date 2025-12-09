import 'package:cappla/core/utils/street_alerts.dart';
import 'package:cappla/features/publication/presentation/screens/home_screen.dart';
import 'package:cappla/features/publication/presentation/screens/map_screen.dart';
import 'package:cappla/features/publication/presentation/screens/profile_screen.dart';
import 'package:cappla/features/shared/providers/navigation_provider.dart';
import 'package:cappla/features/shared/widget/street_nav_bar.dart'; // Asegúrate que la ruta sea correcta
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importante
import 'package:provider/provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // Instancia local del plugin para usarlo aquí
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Definimos el canal aquí también para tener acceso a sus ID (debe coincidir con el de main.dart)
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'Notificaciones Importantes', // title
    description: 'Este canal se usa para notificaciones importantes.',
    importance: Importance.max,
  );

  @override
  void initState() {
    super.initState();
    _setupForegroundNotifications();
  }

  void _setupForegroundNotifications() {
    // ESCUCHAR NOTIFICACIONES EN PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Si hay una notificación y estamos en Android
      if (notification != null && android != null) {
        
        // MOSTRAR EL BANNER VISUALMENTE
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher', // Asegúrate de que este ícono exista
              color: const Color(0xFF00FF88), 
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
        StreetAlerts.show(context, notification.body ?? "Nueva interacción", AlertType.info);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final currentIndex = navProvider.currentIndex;

    final List<Widget> widgetOptions = <Widget>[
      const HomeScreen(), // Tab 0
      const MapScreen(), // Tab 1
      const ProfileScreen(),
    ];

    return Scaffold(
      // Esto permite que el contenido llegue hasta abajo del todo (detrás de la barra)
      extendBody: true, 
      
      body: widgetOptions.elementAt(currentIndex),
      
      // En lugar de 'bottomNavigationBar' nativo, usamos el nuestro
      bottomNavigationBar: StreetNavBar(
        currentIndex: currentIndex,
        onTap: (index) => navProvider.setIndex(index),
      ),
    );
  }
}
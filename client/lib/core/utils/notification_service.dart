import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

static Future<String?> getToken() async {
    // PARCHE PARA iOS: Esperar al token de Apple
    if (Platform.isIOS) {
      // Intentamos obtener el APNS token primero
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      
      // Si es nulo, esperamos un poco (a veces tarda milisegundos)
      if (apnsToken == null) {
        print("Esperando APNS token...");
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await _firebaseMessaging.getAPNSToken();
      }

      if (apnsToken == null) {
        print("ERROR CRÍTICO: No se pudo obtener APNS token de Apple.");
        return null; // Si no hay APNS, Firebase fallará, mejor abortar.
      }
    }

    try {
      String? token = await _firebaseMessaging.getToken();
      print("🔔 FCM TOKEN: $token");
      return token;
    } catch (e) {
      print("Error obteniendo token FCM: $e");
      return null;
    }
  }
}

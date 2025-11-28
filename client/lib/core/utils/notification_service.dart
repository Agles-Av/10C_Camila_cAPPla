import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<String?> getToken() async {
    // En Android 13+ esto pedirá permiso automáticamente la primera vez
    await _firebaseMessaging.requestPermission();

    try {
      String? token = await _firebaseMessaging.getToken();
      print("🔔 FCM TOKEN ANDROID: $token");
      return token;
    } catch (e) {
      print("Error obteniendo token: $e");
      return null;
    }
  }
}

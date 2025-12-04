import 'package:cappla/core/config/dio_client.dart';
import 'package:cappla/features/auth/data/models/register_dto.dart';
import '../models/login_dto.dart';
import '../models/auth_response.dart';

class AuthService {
  final DioClient dioClient;

  AuthService(this.dioClient);

  Future<AuthResponse> login(LoginDto dto) async {
    final response = await dioClient.dio.post(
      "/auth/login",
      data: dto.toJson(),
    );

    if (response.data != null) {
      return AuthResponse.fromJson(response.data);
    }

    throw Exception("Error al iniciar sesión");
  }

  Future<bool> updatePassword(int id, LoginDto dto) async {
    final response = await dioClient.dio.put(
      "/auth/updatePassword/$id",
      data: dto.toJson(),
    );

    return response.statusCode == 200;
  }

  Future<bool> updateProfile(int id, Map<String, dynamic> data) async {
    final response = await dioClient.dio.put(
      "/auth/updateProfile/$id",
      data: data,
    );

    return response.statusCode == 200;
  }

  Future<bool> register(RegisterDto dto) async {
    // <--- CAMBIA 'Map' por 'RegisterDto'
    try {
      final response = await dioClient.dio.post(
        "/auth/register",
        data: dto.toJson(), // <--- AQUÍ SE CONVIERTE A MAP
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception("Error al registrar");
    }
  }

  Future<void> syncFcmToken(int userId, String token) async {
    try {
      // Usamos queryParameters porque en Java usaste @RequestParam
      // Nota: Verifica si tu backend requiere "/auth/update-fcm-token" o solo "/update-fcm-token"
      await dioClient.dio.post(
        "/update-fcm-token",
        queryParameters: {"userId": userId, "token": token},
      );
      print("Token FCM enviado correctamente al servidor.");
    } catch (e) {
      print("Error silenciado enviando FCM token: $e");
    }
  }
}

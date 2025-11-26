import 'package:cappla/core/config/dio_client.dart';
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

  Future<bool> register(Map<String, dynamic> userData) async {
    final response = await dioClient.dio.post("/auth/register", data: userData);

    return response.statusCode == 200;
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
}

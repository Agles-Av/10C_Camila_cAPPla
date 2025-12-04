import 'package:cappla/features/auth/data/models/user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // 1. Primero accedemos al nodo 'data'
    // Si por alguna razón 'data' no viene, esto evitará un crash feo (opcional check de nulidad)
    final data = json["data"];

    return AuthResponse(
      // 2. Ahora sacamos la info desde dentro de 'data'
      token: data["token"],
      user: UserModel.fromJson(data["user"]),
    );
  }
}

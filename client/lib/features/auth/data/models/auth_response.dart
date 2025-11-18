import 'package:cappla/features/auth/data/models/user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json["token"],
    user: UserModel.fromJson(json["user"]),
  );
}

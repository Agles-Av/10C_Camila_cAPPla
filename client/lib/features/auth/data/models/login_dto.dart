class LoginDto {
  final String email;
  final String contrasena;

  LoginDto({required this.email, required this.contrasena});

  Map<String, dynamic> toJson() => {"email": email, "contrasena": contrasena};
}

class RegisterDto {
  final String nombre;
  final String email;
  final String contrasena;
  final bool status;

  RegisterDto({
    required this.nombre,
    required this.email,
    required this.contrasena,
    this.status = true, // Por defecto activo al registrarse
  });

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "email": email,
    "contrasena": contrasena,
    "status": status,
  };
}

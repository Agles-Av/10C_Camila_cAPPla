class UserModel {
  final int id;
  final String nombre;
  final String email;
  final String? foto;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    nombre: json["nombre"] ?? "",
    email: json["email"] ?? "",
    foto: json["foto"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "email": email,
    "foto": foto,
  };
}

import 'package:cappla/features/auth/data/models/user_model.dart';

class ImageModel {
  final int id;
  final String url;

  ImageModel({required this.id, required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      ImageModel(id: json["id"] ?? 0, url: json["url"] ?? "");
}

class LikeModel {
  final int id;
  final UserModel user;

  LikeModel({required this.id, required this.user});

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      LikeModel(id: json["id"], user: UserModel.fromJson(json["user"]));
}

class PublicationModel {
  final int id;
  final String titulo;
  final String descripcion;
  final List<ImageModel> imagenes;
  final UserModel user;
  final double longitud;
  final double latitud;
  final List<LikeModel> likes;

  PublicationModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagenes,
    required this.user,
    required this.longitud,
    required this.latitud,
    required this.likes,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    return PublicationModel(
      id: json["id"],
      titulo: json["titulo"] ?? "Sin título",
      descripcion: json["descripcion"] ?? "",

      // Imágenes
      imagenes:
          (json["imagenes"] as List?)
              ?.map((x) => ImageModel.fromJson(x))
              .toList() ??
          [],

      user: UserModel.fromJson(json["user"]),
      longitud: (json["longitud"] as num).toDouble(),
      latitud: (json["latitud"] as num).toDouble(),

      // --- CORRECCIÓN AQUÍ ---
      // Usamos List<LikeModel>.from para garantizar el tipo exacto
      likes: json["likes"] == null
          ? [] // Si es null, devolvemos lista vacía
          : List<LikeModel>.from(
              (json["likes"] as List).map((x) => LikeModel.fromJson(x)),
            ),
    );
  }
}

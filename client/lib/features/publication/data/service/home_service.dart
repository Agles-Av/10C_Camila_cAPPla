import 'package:cappla/core/config/dio_client.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class HomeService {
  final DioClient _dioClient;

  HomeService(this._dioClient);

  Future<List<PublicationModel>> getPublications() async {
    try {
      final response = await _dioClient.dio.get("/publication");

      final List<dynamic> data = response.data['data'] ?? response.data;
      print(data);
      return data.map((json) => PublicationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error al cargar publicaciones");
    }
  }

  // Agrega este método dentro de la clase HomeService
  Future<bool> toggleLike(int publicationId, int userId) async {
    try {
      // Ajusta la ruta según tu Controller de Java.
      // Basado en tu log anterior, parece ser: /publication/like/...
      final response = await _dioClient.dio.patch(
        "/publication/like/$publicationId/user/$userId",
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error al dar like");
    }
  }

  Future<List<PublicationModel>> getPublicationsByUser(int userId) async {
    try {
      // Llamamos al nuevo endpoint: /publication/user/{id}
      final response = await _dioClient.dio.get("/publication/$userId");

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => PublicationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error al cargar publicaciones del usuario");
    }
  } 

  Future<bool> createPublication({
    required String titulo,
    required String descripcion,
    required double latitud,
    required double longitud,
    required int userId,
    required List<XFile> images,
  }) async {
    try {
      // Preparamos el FormData (Multipart)
      final formData = FormData.fromMap({
        "titulo": titulo,
        "descripcion": descripcion,
        "latitud": latitud,
        "longitud": longitud,
        "userId": userId,
      });

      // Agregamos las imágenes al FormData
      for (var file in images) {
        formData.files.add(MapEntry(
          "imagenes", // El nombre debe coincidir con @RequestPart("imagenes")
          await MultipartFile.fromFile(file.path, filename: file.name),
        ));
      }

      final response = await _dioClient.dio.post(
        "/publication",
        data: formData,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception("Error creando publicación: $e");
    }
  }

  // 2. ACTUALIZAR PUBLICACIÓN
  Future<bool> updatePublication({
    required int id,
    required String titulo,
    required String descripcion,
    required double latitud,
    required double longitud,
    required int userId,
    required List<XFile> images, // Nuevas imágenes (si se envían)
  }) async {
    try {
      final formData = FormData.fromMap({
        "titulo": titulo,
        "descripcion": descripcion,
        "latitud": latitud,
        "longitud": longitud,
        "userId": userId,
      });

      // Solo agregamos archivos si el usuario seleccionó nuevas
      if (images.isNotEmpty) {
        for (var file in images) {
          formData.files.add(MapEntry(
            "imagenes",
            await MultipartFile.fromFile(file.path, filename: file.name),
          ));
        }
      } 
      // NOTA: Tu backend actual borra las fotos viejas siempre. 
      // Si mandas lista vacía, el post se quedará sin fotos.

      final response = await _dioClient.dio.put(
        "/publication/$id",
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error actualizando publicación: $e");
    }
  }

  // 3. ELIMINAR PUBLICACIÓN
  Future<bool> deletePublication(int id) async {
    try {
      final response = await _dioClient.dio.delete("/publication/$id");
      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error eliminando publicación");
    }
  }
}

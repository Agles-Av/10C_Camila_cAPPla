import 'package:cappla/core/config/dio_client.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';

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
}

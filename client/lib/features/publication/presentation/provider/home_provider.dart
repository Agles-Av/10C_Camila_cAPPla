import 'package:cappla/features/auth/data/models/user_model.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/data/service/home_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  HomeService? _homeService;

  HomeProvider();

  void update(HomeService service) {
    _homeService = service;
  }

  List<PublicationModel> _publications = [];
  bool _isLoading = false;

  List<PublicationModel> get publications => _publications;
  bool get isLoading => _isLoading;

  PublicationModel? _selectedPublication;
  PublicationModel? get selectedPublication => _selectedPublication;

  void selectPublication(PublicationModel? pub) {
    _selectedPublication = pub;
    notifyListeners();
  }

  Future<void> loadPublications() async {
    if (_homeService == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _publications = await _homeService!.getPublications();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(int pubId, UserModel currentUser) async {
    if (_homeService == null) return;

    // 1. Encontrar la publicación en la lista local
    final index = _publications.indexWhere((p) => p.id == pubId);
    if (index == -1) return;

    final publication = _publications[index];

    // 2. Verificar si ya le di like
    final isLiked = publication.likes.any(
      (like) => like.user.id == currentUser.id,
    );

    // 3. ACTUALIZACIÓN OPTIMISTA (Modificamos la lista localmente primero)
    List<LikeModel> updatedLikes = List.from(publication.likes);

    if (isLiked) {
      // Si ya tenía like, lo quitamos
      updatedLikes.removeWhere((like) => like.user.id == currentUser.id);
    } else {
      // Si no tenía, agregamos un Like falso temporalmente para que se vea rojo
      updatedLikes.add(
        LikeModel(
          id: 0, // ID temporal, no importa para la UI visual
          user: currentUser,
        ),
      );
    }

    // Creamos una copia de la publicación con la nueva lista de likes
    // (Necesitas asegurarte que PublicationModel tenga copyWith o crear uno nuevo así:)
    final updatedPublication = PublicationModel(
      id: publication.id,
      titulo: publication.titulo,
      descripcion: publication.descripcion,
      imagenes: publication.imagenes,
      user: publication.user,
      longitud: publication.longitud,
      latitud: publication.latitud,
      likes: updatedLikes,
    );

    // Actualizamos la lista principal y notificamos a la UI
    _publications[index] = updatedPublication;
    notifyListeners();

    // 4. LLAMADA AL SERVIDOR (En segundo plano)
    try {
      await _homeService!.toggleLike(pubId, currentUser.id);
      // Si éxito, no hacemos nada (ya la UI está actualizada)
    } catch (e) {
      // 5. SI FALLA: REVERTIMOS LOS CAMBIOS
      print("Error dando like: $e");
      _publications[index] = publication; // Volvemos al objeto original
      notifyListeners();
    }
  }
}

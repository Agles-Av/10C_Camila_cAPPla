import 'package:cappla/features/auth/data/models/user_model.dart';
import 'package:cappla/features/publication/data/model/publication_model.dart';
import 'package:cappla/features/publication/data/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  List<PublicationModel> _myPublications = [];
  bool _isLoadingProfile = false;

  List<PublicationModel> get myPublications => _myPublications;
  bool get isLoadingProfile => _isLoadingProfile;

  // 2. NUEVO MÉTODO: Cargar perfil desde el servidor
  Future<void> loadMyPublications(int userId) async {
    if (_homeService == null) return;

    _isLoadingProfile = true;
    notifyListeners();

    try {
      // Llamamos al servicio nuevo
      _myPublications = await _homeService!.getPublicationsByUser(userId);
    } catch (e) {
      print("Error cargando perfil: $e");
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // 3. Método de Likes en perfil (opcional, pero recomendado)
  // Calcula los likes basado en la lista que acabamos de bajar
  int getTotalLikesFromProfile() {
    return _myPublications.fold(0, (sum, pub) => sum + pub.likes.length);
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

  Future<bool> createPost(
    String titulo,
    String desc,
    double lat,
    double lng,
    int userId,
    List<XFile> images,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _homeService!.createPublication(
        titulo: titulo,
        descripcion: desc,
        latitud: lat,
        longitud: lng,
        userId: userId,
        images: images,
      );
      if (success) {
        // Recargamos la lista del perfil para ver el nuevo post
        await loadMyPublications(userId);
      }
      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePost(
    int pubId,
    String titulo,
    String desc,
    double lat,
    double lng,
    int userId,
    List<XFile> newImages,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _homeService!.updatePublication(
        id: pubId,
        titulo: titulo,
        descripcion: desc,
        latitud: lat,
        longitud: lng,
        userId: userId,
        images: newImages,
      );

      if (success) {
        // Actualizamos la lista localmente o recargamos
        await loadMyPublications(userId);
      }
      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePost(int pubId, int userId) async {
    // Optimismo UI: Lo quitamos visualmente primero
    final index = _myPublications.indexWhere((p) => p.id == pubId);
    PublicationModel? backup;
    
    if (index != -1) {
      backup = _myPublications[index];
      _myPublications.removeAt(index);
      notifyListeners();
    }

    try {
      final success = await _homeService!.deletePublication(pubId);
      if (!success && backup != null) {
        // Si falla, lo devolvemos
        _myPublications.insert(index, backup);
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (backup != null) {
        _myPublications.insert(index, backup);
        notifyListeners();
      }
      return false;
    }
  }
}

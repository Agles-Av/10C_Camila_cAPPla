import 'package:cappla/core/config/dio_client.dart';
import 'package:cappla/features/auth/data/models/login_dto.dart';
import 'package:cappla/features/auth/data/models/user_model.dart';
import 'package:cappla/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cappla/core/config/error_state.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLogged => _token != null;

  Future<void> login(BuildContext context, LoginDto dto) async {
    _isLoading = true;
    notifyListeners();

    try {
      final service = AuthService(DioClient());
      final data = await service.login(dto);

      _token = data.token;
      _user = data.user;

      await _saveSession();
    } catch (e) {
      Provider.of<ErrorState>(context, listen: false)
        ..setError("Error al iniciar sesión")
        ..showErrorDialog(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user");
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", _token!);
    await prefs.setString("user", _user!.toString());
  }

  // Cargar sesión al iniciar la app
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("token");
    final storedUser = prefs.getString("user");

    if (storedToken != null && storedUser != null) {
      _token = storedToken;
      _user = UserModel.fromJson(
        Map<String, dynamic>.from(evalJson(storedUser)),
      );
      notifyListeners();
    }
  }

  // Convertir el string almacenado a json real
  Map<String, dynamic> evalJson(String raw) {
    raw = raw.replaceAll(RegExp(r'[{}]'), '');
    final map = <String, dynamic>{};

    for (var p in raw.split(',')) {
      final kv = p.split(':');
      if (kv.length == 2) {
        map[kv[0].trim()] = kv[1].trim();
      }
    }

    return map;
  }
}

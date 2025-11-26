import 'dart:convert';
import 'package:cappla/features/auth/data/models/auth_response.dart';
import 'package:cappla/features/auth/data/models/login_dto.dart';
import 'package:cappla/features/auth/data/models/user_model.dart';
import 'package:cappla/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  AuthService? _authService;

  AuthProvider();

  void update(AuthService service) {
    _authService = service;
  }

  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLogged => _token != null;

  // -------------------------
  // LOGIN
  // -------------------------
  Future<void> login(LoginDto dto) async {
    _isLoading = true;
    notifyListeners();

    try {
      final AuthResponse result = await _authService!.login(dto);

      _token = result.token;
      _user = result.user;

      await _saveSession();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------
  // LOGOUT
  // -------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user");
    _token = null;
    _user = null;
    notifyListeners();
  }

  // -------------------------
  // SESSION SAVE/LOAD
  // -------------------------
  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", _token!);
    await prefs.setString("user", jsonEncode(_user!.toJson()));
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("token");
    final storedUser = prefs.getString("user");

    if (storedToken != null && storedUser != null) {
      _token = storedToken;
      _user = UserModel.fromJson(jsonDecode(storedUser));
      notifyListeners();
    }
  }
}

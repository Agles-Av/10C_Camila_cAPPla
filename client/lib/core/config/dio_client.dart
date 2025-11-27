import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    _setupBadCertificateHandler();
    _setupLogging();
    _setupInterceptors();
  }

  // ---------------------------------------------------------------------------
  // Ignorar certificados solo en DEV
  // ---------------------------------------------------------------------------
  void _setupBadCertificateHandler() {
    if (!Env.allowBadCert) return;

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
                return Env.isDev; // SOLO en desarrollo
              };
          return client;
        };
  }

  // ---------------------------------------------------------------------------
  // Logs solo en modo debug
  // ---------------------------------------------------------------------------
  void _setupLogging() {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Interceptores de token y manejo de errores
  // ---------------------------------------------------------------------------
  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          // --- CORRECCIÓN AQUÍ ---
          // En lugar de buscar '/public', excluimos las rutas de '/auth'
          // (que son login y register, las únicas que no necesitan token).

          final isAuthRoute = options.path.contains('/auth');

          if (token != null && !isAuthRoute) {
            options.headers['Authorization'] = 'Bearer $token';
            // print("--> Token agregado a ${options.path}"); // Debug
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Opcional: Aquí podrías limpiar el token si expiró
          }
          return handler.next(e);
        },
      ),
    );
  }
}

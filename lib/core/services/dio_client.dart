import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'secure_storage.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
        validateStatus: (status) {
          return status! < 500; // Accept 200-499, reject 500+
        },
      ),
    );

    // Interceptor 1: Logging (hanya debug mode)
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => debugPrint('[DIO] $object'),
        ),
      );
    }

    // Interceptor 2: Auth Token (Backend JWT)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil token dari secure storage (JWT dari Go backend)
          final token = await SecureStorageService.getToken();
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            if (kDebugMode) {
              debugPrint('[AUTH] Token injected: Bearer ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
            }
          }
          
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle 401 Unauthorized (Token expired/invalid)
          if (error.response?.statusCode == 401) {
            debugPrint('[AUTH] Token expired or invalid. Clearing storage...');
            await SecureStorageService.clearAll();
            
            // Optional: Trigger logout event atau navigasi ke login
            // Bisa menggunakan navigatorKey atau event bus
          }
          
          // Handle 403 Forbidden
          if (error.response?.statusCode == 403) {
            debugPrint('[AUTH] Access forbidden');
          }
          
          return handler.next(error);
        },
      ),
    );

    // Interceptor 3: Retry Logic (Optional)
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) async {
          // Retry jika timeout atau network error
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError) {
            
            debugPrint('[NETWORK] Connection issue, consider retry logic here');
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  // Method untuk clear instance (berguna saat logout)
  static void reset() {
    _instance = null;
  }
}
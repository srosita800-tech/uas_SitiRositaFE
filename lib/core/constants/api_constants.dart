class ApiConstants {
  // Ganti dengan IP/Domain backend Golang Anda
  // Untuk Android Emulator: 10.0.2.2
  // Untuk iOS Simulator: localhost
  // Untuk Device: IP Local network (Cek IP Laptop Anda!)
  // Backend port di .env adalah 8081
  static const String baseUrl = 'http://192.168.1.35:8081/v1';

  // Auth Endpoints (sesuai kontrak backend Go)
  static const String verifyToken = '/auth/verify-token';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Product Endpoints
  static const String products = '/products';
  static const String categories = '/categories';

  // User Endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';

  // Timeout (milliseconds)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}

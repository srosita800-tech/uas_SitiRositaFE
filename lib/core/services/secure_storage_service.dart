import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'backend_token';

  // Menyimpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Mengambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Menghapus token (Logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Menghapus semua data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

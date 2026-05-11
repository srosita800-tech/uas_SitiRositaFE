
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Map<String, dynamic>> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstants.verifyToken,
      data: {'firebase_token': firebaseToken},
    );

    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    if (statusCode != 200 || responseData == null) {
      final message = responseData?['message'] ?? 'Gagal verifikasi token';
      final errorCode = responseData?['error_code'] ?? 'UNKNOWN_ERROR';
      throw Exception('[$errorCode] $message');
    }

    final data = responseData['data'];
    if (data == null || data['access_token'] == null) {
      throw Exception('Response backend tidak mengandung access_token');
    }

    return data;
  }
}
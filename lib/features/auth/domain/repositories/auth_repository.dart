abstract class AuthRepository {
  Future<Map<String, dynamic>> verifyFirebaseToken(String firebaseToken);
}
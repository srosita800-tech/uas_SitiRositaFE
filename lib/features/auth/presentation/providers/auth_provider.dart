import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, emailNotVerified, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;
  String? errorMessage;
  Timer? _timer;
  Map<String, dynamic>? _userData;

  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;

  // Mendapatkan data user saat ini
  User? get currentUser => _auth.currentUser;
  User? get firebaseUser => currentUser;
  
  // Sekarang userModel mengembalikan data dari backend yang berbentuk Map
  Map<String, dynamic>? get userModel => _userData?['user'];
  bool get isAdmin => userModel?['role'] == 'admin';

  Future<void> initializeAuth() async {
    final user = _auth.currentUser;
    debugPrint("[AUTH] Initializing Auth. Firebase User: ${user?.email}");
    
    if (user != null) {
      if (user.emailVerified) {
        await _verifyBackend();
      } else {
        debugPrint("[AUTH] User email not verified");
        _status = AuthStatus.emailNotVerified;
      }
    } else {
      debugPrint("[AUTH] No Firebase user found");
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> register({required String email, required String password, required String name}) async {
    _status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Update nama di profil Firebase
      await cred.user?.updateDisplayName(name);
      
      // Kirim email verifikasi
      await cred.user?.sendEmailVerification();
      
      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapFirebaseError(e.code);
      _status = AuthStatus.error;
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat pendaftaran";
      _status = AuthStatus.error;
    }
    notifyListeners();
    return false;
  }

  Future<bool> login({required String email, required String password}) async {
    _status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if (cred.user != null) {
        // Cek apakah email sudah diverifikasi
        if (cred.user!.emailVerified) {
          await _verifyBackend();
          return _status == AuthStatus.authenticated;
        } else {
          _status = AuthStatus.emailNotVerified;
          notifyListeners();
          return true; // Login success but email not verified
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapFirebaseError(e.code);
      _status = AuthStatus.error;
    } catch (e) {
      errorMessage = "Gagal masuk ke akun Anda";
      _status = AuthStatus.error;
    }
    notifyListeners();
    return false;
  }

  // Inti koneksi ke Backend Golang
  Future<void> _verifyBackend() async {
    try {
      // Ambil token ID terbaru dari Firebase (paksa refresh agar token valid)
      String? fbToken = await _auth.currentUser?.getIdToken(true);
      
      if (fbToken != null) {
        // 1. Kirim Firebase Token ke Backend Golang Anda
        final response = await _repository.verifyFirebaseToken(fbToken);
        
        // Simpan data user dari backend
        _userData = response;
        
        // Simpan JWT Backend ke Secure Storage untuk digunakan Dio Interceptor
        await SecureStorageService.saveToken(response['access_token']);
        
        _status = AuthStatus.authenticated;
      } else {
        throw Exception("Gagal mendapatkan Firebase Token");
      }
    } catch (e) {
      debugPrint("[AUTH ERROR] Backend Sync Failed: $e");
      errorMessage = "Sinkronisasi server gagal. Silakan coba lagi.";
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  // Memulai pengecekan verifikasi email secara berkala
  void startVerificationCheck(VoidCallback onSuccess) {
    // Pastikan tidak ada timer ganda
    _timer?.cancel();
    
    debugPrint("[AUTH] Starting verification timer...");
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      
      if (user != null && user.emailVerified) {
        timer.cancel();
        _timer = null;
        debugPrint("[AUTH] Email verified successfully!");
        await _verifyBackend();
        onSuccess();
      }
    });
  }

  // Menghentikan timer (Penting dipanggil di dispose halaman)
  void stopCheck() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      debugPrint("[AUTH] Verification timer stopped manually");
    }
  }

  Future<void> logout() async {
    stopCheck(); // Stop timer jika masih jalan
    await _auth.signOut();
    await SecureStorageService.deleteToken(); // Hapus JWT Backend
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Helper untuk pesan error yang lebih user-friendly
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found': return 'Email tidak terdaftar.';
      case 'wrong-password': return 'Password salah.';
      case 'email-already-in-use': return 'Email sudah digunakan oleh akun lain.';
      case 'invalid-email': return 'Format email tidak valid.';
      case 'weak-password': return 'Password terlalu lemah.';
      default: return 'Terjadi kesalahan sistem. Coba lagi.';
    }
  }

  @override
  void dispose() {
    stopCheck();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Memberikan waktu splash screen tampil (minimal 2 detik)
    final splashFuture = Future.delayed(const Duration(seconds: 2));
    
    // Inisialisasi auth state (cek Firebase + Backend sync)
    final authProvider = context.read<AuthProvider>();
    final authFuture = authProvider.initializeAuth();
    
    // Tunggu keduanya selesai
    await Future.wait([splashFuture, authFuture]);
    
    if (!mounted) return;
    
    final status = authProvider.status;
    
    if (status == AuthStatus.authenticated) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else if (status == AuthStatus.emailNotVerified) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_rounded, 
              size: 100, 
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
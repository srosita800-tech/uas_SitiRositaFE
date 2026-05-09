import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports
import 'package:uts_uas1125170150sitirosita/core/theme/app_theme.dart';
import 'package:uts_uas1125170150sitirosita/firebase_options.dart';
import 'package:uts_uas1125170150sitirosita/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_uas1125170150sitirosita/features/product/presentation/providers/product_provider.dart';
import 'package:uts_uas1125170150sitirosita/core/providers/theme_provider.dart';
import 'package:uts_uas1125170150sitirosita/core/router/app_router.dart';
import 'package:uts_uas1125170150sitirosita/features/dashboard/presentation/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BagStore Premium',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
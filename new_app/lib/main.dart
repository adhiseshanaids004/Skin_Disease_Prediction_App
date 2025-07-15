import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_provider.dart';
import 'theme/theme_config.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'bottom_nav_controller.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'routes.dart'; 
import 'services/ai_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
  await AIService.initialize();
} catch (e) {
  debugPrint('Failed to initialize AI Service: $e');
}

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('language_code') ?? 'en';
  final locale = Locale(languageCode);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkMode: isDarkMode, prefs: prefs),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ta')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        startLocale: locale,
        saveLocale: true,
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'app_name'.tr(),
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const SplashScreen(), // ✅ Always starts with splash screen
          routes: {
            Routes.login: (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/home': (context) => const BottomNavController(), // optional if needed
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/app_provider.dart';
import 'data/providers/professional_provider.dart';
import 'data/providers/appointment_provider.dart';
import 'data/providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation des préférences partagées
  final prefs = await SharedPreferences.getInstance();
  
  // Initialiser l'état d'authentification
  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ProfessionalProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: AQuiVeutApp(prefs: prefs),
    ),
  );
}

class AQuiVeutApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const AQuiVeutApp({
    super.key,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp.router(
          title: 'A QUI VEUT ?',
          debugShowCheckedModeBanner: false,
          
          // Thème
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          // Router
          routerConfig: AppRouter.router,
          
          // Configuration globale
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0, // Éviter le redimensionnement du texte
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}

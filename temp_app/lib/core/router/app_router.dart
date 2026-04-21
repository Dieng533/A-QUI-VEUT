import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String appointments = '/appointments';
  static const String chatbot = '/chatbot';
  static const String map = '/map';
  static const String profile = '/profile';
  static const String notifications = '/notifications';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Routes (Bottom Navigation)
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      GoRoute(
        path: appointments,
        name: 'appointments',
        builder: (context, state) => const AppointmentsScreen(),
      ),
      
      GoRoute(
        path: chatbot,
        name: 'chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),
      
      GoRoute(
        path: map,
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),
      
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Notifications
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    
    // Redirection logic
    redirect: (context, state) {
      // Pour l'instant, on laisse la navigation normale
      // Plus tard, on ajoutera la logique d'authentification ici
      return null;
    },
  );
}

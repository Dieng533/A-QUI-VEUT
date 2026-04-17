import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:a_qui_veut/main.dart';
import 'package:a_qui_veut/data/providers/auth_provider.dart';
import 'package:a_qui_veut/data/providers/app_provider.dart';

void main() {
  group('A QUI VEUT ? App Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: const AQuiVeutApp(prefs: null),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Splash screen should display logo and app name', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: const AQuiVeutApp(prefs: null),
        ),
      );

      // Wait for splash screen to load
      await tester.pumpAndSettle();

      // Verify splash screen elements
      expect(find.text('A QUI VEUT ?'), findsOneWidget);
      expect(find.text('Votre santé, plus proche de vous'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('Navigation should work between screens', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: const AQuiVeutApp(prefs: null),
        ),
      );

      // Wait for initial screen
      await tester.pumpAndSettle();

      // Test navigation (this will need to be updated based on actual navigation flow)
      // For now, just verify the app structure
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Theme should apply correctly', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: const AQuiVeutApp(prefs: null),
        ),
      );

      // Verify theme is applied
      await tester.pumpAndSettle();
      
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
    });
  });

  group('AuthProvider Tests', () {
    test('Initial state should be correct', () {
      final authProvider = AuthProvider();
      
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.user, isNull);
    });

    test('Login with valid credentials should succeed', () async {
      final authProvider = AuthProvider();
      
      await authProvider.login('test@example.com', 'password');
      
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.user, isNotNull);
      expect(authProvider.errorMessage, isNull);
    });

    test('Login with invalid credentials should fail', () async {
      final authProvider = AuthProvider();
      
      await authProvider.login('invalid@email.com', 'wrongpassword');
      
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.errorMessage, isNotNull);
    });

    test('Logout should clear user state', () async {
      final authProvider = AuthProvider();
      
      // First login
      await authProvider.login('test@example.com', 'password');
      expect(authProvider.isAuthenticated, isTrue);
      
      // Then logout
      await authProvider.logout();
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.user, isNull);
    });
  });

  group('AppProvider Tests', () {
    test('Initial state should be correct', () {
      final appProvider = AppProvider();
      
      expect(appProvider.isDarkMode, isFalse);
      expect(appProvider.notificationsEnabled, isTrue);
      expect(appProvider.language, equals('fr'));
      expect(appProvider.isFirstLaunch, isTrue);
    });

    test('Toggle dark mode should work', () async {
      final appProvider = AppProvider();
      
      await appProvider.toggleDarkMode();
      expect(appProvider.isDarkMode, isTrue);
      
      await appProvider.toggleDarkMode();
      expect(appProvider.isDarkMode, isFalse);
    });

    test('Toggle notifications should work', () async {
      final appProvider = AppProvider();
      
      await appProvider.toggleNotifications();
      expect(appProvider.notificationsEnabled, isFalse);
      
      await appProvider.toggleNotifications();
      expect(appProvider.notificationsEnabled, isTrue);
    });

    test('Change language should work', () async {
      final appProvider = AppProvider();
      
      await appProvider.changeLanguage('en');
      expect(appProvider.language, equals('en'));
    });

    test('Complete first launch should work', () async {
      final appProvider = AppProvider();
      
      await appProvider.completeFirstLaunch();
      expect(appProvider.isFirstLaunch, isFalse);
    });
  });

  group('Widget Tests', () {
    testWidgets('CustomButton should render correctly', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () => buttonPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      
      await tester.tap(find.byType(CustomButton));
      expect(buttonPressed, isTrue);
    });

    testWidgets('CustomTextField should render correctly', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              label: 'Test Field',
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
      
      await tester.enterText(find.byType(TextFormField), 'Hello World');
      expect(controller.text, equals('Hello World'));
    });
  });
}

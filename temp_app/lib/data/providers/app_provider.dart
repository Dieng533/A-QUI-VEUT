import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'fr';
  bool _isFirstLaunch = true;

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get isFirstLaunch => _isFirstLaunch;

  AppProvider() {
    _loadPreferences();
  }

  // Charger les préférences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _language = prefs.getString('language') ?? 'fr';
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des préférences: $e');
    }
  }

  // Sauvegarder les préférences
  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setString('language', _language);
      await prefs.setBool('isFirstLaunch', _isFirstLaunch);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des préférences: $e');
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _savePreferences();
    notifyListeners();
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _savePreferences();
    notifyListeners();
  }

  // Changer la langue
  Future<void> changeLanguage(String language) async {
    _language = language;
    await _savePreferences();
    notifyListeners();
  }

  // Marquer le premier lancement comme terminé
  Future<void> completeFirstLaunch() async {
    _isFirstLaunch = false;
    await _savePreferences();
    notifyListeners();
  }

  // Réinitialiser les préférences
  Future<void> resetPreferences() async {
    _isDarkMode = false;
    _notificationsEnabled = true;
    _language = 'fr';
    await _savePreferences();
    notifyListeners();
  }
}

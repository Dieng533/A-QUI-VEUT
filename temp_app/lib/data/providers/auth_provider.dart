import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;

  // Login
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulation de validation
      if (email == 'test@example.com' && password == 'password') {
        _isAuthenticated = true;
        _user = {
          'id': '1',
          'email': email,
          'name': 'Utilisateur Test',
          'phone': '+221 77 123 45 67',
        };
      } else {
        _setError('Email ou mot de passe incorrect');
      }
    } catch (e) {
      _setError('Une erreur est survenue');
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<void> register(String name, String phone, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simuler un appel API
      await Future.delayed(const Duration(seconds: 2));
      
      _isAuthenticated = true;
      _user = {
        'id': '1',
        'name': name,
        'phone': phone,
        'email': email,
      };
    } catch (e) {
      _setError('Une erreur est survenue lors de l\'inscription');
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isAuthenticated = false;
      _user = null;
    } catch (e) {
      _setError('Une erreur est survenue lors de la déconnexion');
    } finally {
      _setLoading(false);
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 2));
      // Simuler l'envoi d'email
    } catch (e) {
      _setError('Une erreur est survenue');
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _user = {...?_user, ...userData};
    } catch (e) {
      _setError('Une erreur est survenue lors de la mise à jour');
    } finally {
      _setLoading(false);
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

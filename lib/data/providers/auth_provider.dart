import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

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
      final apiService = ApiService();
      final response = await apiService.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      
      // Sauvegarder les tokens
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      
      // Mettre à jour l'utilisateur
      _isAuthenticated = true;
      _user = data['user'];
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<void> register(String firstName, String lastName, String email, String password, String passwordConfirm, {String? phone}) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.post(
        ApiConfig.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          if (phone != null) 'phone': phone,
        },
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();
      
      // Sauvegarder les tokens
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      
      // Mettre à jour l'utilisateur
      _isAuthenticated = true;
      _user = data['user'];
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Supprimer les tokens
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      
      // Réinitialiser l'état
      _isAuthenticated = false;
      _user = null;
      
      notifyListeners();
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
      final apiService = ApiService();
      await apiService.post(
        '${ApiConfig.baseUrl}/auth/password-reset/',
        data: {'email': email},
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.patch(
        ApiConfig.profile,
        data: userData,
      );

      _user = response.data;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      if (token != null) {
        final apiService = ApiService();
        final response = await apiService.get(ApiConfig.profile);
        
        _isAuthenticated = true;
        _user = response.data;
        notifyListeners();
      }
    } catch (e) {
      // Token invalide, déconnexion
      await logout();
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

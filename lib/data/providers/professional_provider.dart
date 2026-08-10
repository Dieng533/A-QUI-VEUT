import 'package:flutter/foundation.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

class ProfessionalProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _professionals = [];
  Map<String, dynamic>? _professional;
  Map<String, dynamic>? _dashboard;
  List<Map<String, dynamic>> _availabilities = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get professionals => _professionals;
  Map<String, dynamic>? get professional => _professional;
  Map<String, dynamic>? get dashboard => _dashboard;
  List<Map<String, dynamic>> get availabilities => _availabilities;

  // Récupérer tous les professionnels
  Future<void> getProfessionals() async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(ApiConfig.professionals);
      
      _professionals = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer un professionnel par ID
  Future<void> getProfessional(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get('${ApiConfig.professionalDetail}$id/');
      
      _professional = response.data;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Créer un professionnel
  Future<void> createProfessional(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.post(ApiConfig.professionalCreate, data: data);
      
      _professional = response.data;
      _professionals.add(response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un professionnel
  Future<void> updateProfessional(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.patch('${ApiConfig.professionalUpdate}$id/', data: data);
      
      _professional = response.data;
      
      // Mettre à jour la liste
      final index = _professionals.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _professionals[index] = response.data;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Supprimer un professionnel
  Future<void> deleteProfessional(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      await apiService.delete('${ApiConfig.professionalDelete}$id/');
      
      _professionals.removeWhere((p) => p['id'] == id);
      if (_professional?['id'] == id) {
        _professional = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer le dashboard d'un professionnel
  Future<void> getProfessionalDashboard() async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(ApiConfig.professionalDashboard);
      
      _dashboard = response.data;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Rechercher des professionnels
  Future<void> searchProfessionals(String query) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.professionals,
        queryParameters: {'search': query},
      );
      
      _professionals = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par spécialité
  Future<void> filterBySpecialty(String specialty) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.professionals,
        queryParameters: {'specialty': specialty},
      );
      
      _professionals = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer les disponibilités d'un professionnel
  Future<void> getAvailabilities(int professionalId) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get('${ApiConfig.availabilityList}$professionalId/disponibilites/');
      
      _availabilities = List<Map<String, dynamic>>.from(response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Créer une disponibilité
  Future<void> createAvailability(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      print('DEBUG PROVIDER - Creating availability with data: $data');
      final response = await apiService.post(ApiConfig.availabilityCreate, data: data);
      print('DEBUG PROVIDER - Availability created: ${response.data}');
      
      _availabilities.add(response.data);
      notifyListeners();
    } catch (e) {
      print('DEBUG PROVIDER - Error creating availability: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour une disponibilité
  Future<void> updateAvailability(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final url = '${ApiConfig.professionals}disponibilites/$id/';
      print('DEBUG PROVIDER - Updating availability at $url with data: $data');
      final response = await apiService.patch(url, data: data);
      print('DEBUG PROVIDER - Availability updated: ${response.data}');
      
      final index = _availabilities.indexWhere((a) => a['id'] == id);
      if (index != -1) {
        _availabilities[index] = response.data;
      }
      
      notifyListeners();
    } catch (e) {
      print('DEBUG PROVIDER - Error updating availability: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Supprimer une disponibilité
  Future<void> deleteAvailability(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      await apiService.delete('${ApiConfig.availabilityList}disponibilites/$id/');
      
      _availabilities.removeWhere((a) => a['id'] == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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

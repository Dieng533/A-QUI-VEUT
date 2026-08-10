import 'package:flutter/foundation.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

class LocationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _locations = [];
  Map<String, dynamic>? _location;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get locations => _locations;
  Map<String, dynamic>? get location => _location;

  // Récupérer tous les lieux
  Future<void> getLocations() async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(ApiConfig.locations);
      
      _locations = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer un lieu par ID
  Future<void> getLocation(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get('${ApiConfig.locationDetail}$id/');
      
      _location = response.data;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Créer un lieu
  Future<void> createLocation(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.post(ApiConfig.locationCreate, data: data);
      
      _location = response.data;
      _locations.add(response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un lieu
  Future<void> updateLocation(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.patch('${ApiConfig.locationUpdate}$id/', data: data);
      
      _location = response.data;
      
      // Mettre à jour la liste
      final index = _locations.indexWhere((l) => l['id'] == id);
      if (index != -1) {
        _locations[index] = response.data;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Supprimer un lieu
  Future<void> deleteLocation(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      await apiService.delete('${ApiConfig.locationDelete}$id/');
      
      _locations.removeWhere((l) => l['id'] == id);
      if (_location?['id'] == id) {
        _location = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Rechercher des lieux
  Future<void> searchLocations(String query) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.locations,
        queryParameters: {'search': query},
      );
      
      _locations = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par type
  Future<void> filterByType(String type) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.locations,
        queryParameters: {'type': type},
      );
      
      _locations = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par ville
  Future<void> filterByCity(String city) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.locations,
        queryParameters: {'city': city},
      );
      
      _locations = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par proximité (coordonnées)
  Future<void> filterByProximity(double latitude, double longitude, double radius) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.locations,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
      );
      
      _locations = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
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

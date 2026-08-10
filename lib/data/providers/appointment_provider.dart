import 'package:flutter/foundation.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

class AppointmentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _appointments = [];
  Map<String, dynamic>? _appointment;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get appointments => _appointments;
  Map<String, dynamic>? get appointment => _appointment;

  // Récupérer tous les rendez-vous
  Future<void> getAppointments() async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(ApiConfig.appointments);
      
      _appointments = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer un rendez-vous par ID
  Future<void> getAppointment(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get('${ApiConfig.appointmentDetail}$id/');
      
      _appointment = response.data;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Créer un rendez-vous
  Future<void> createAppointment(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.post(ApiConfig.appointmentCreate, data: data);
      
      _appointment = response.data;
      _appointments.add(response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un rendez-vous
  Future<void> updateAppointment(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.patch('${ApiConfig.appointmentDetail}$id/', data: data);
      
      _appointment = response.data;
      
      // Mettre à jour la liste
      final index = _appointments.indexWhere((a) => a['id'] == id);
      if (index != -1) {
        _appointments[index] = response.data;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Supprimer un rendez-vous
  Future<void> deleteAppointment(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      await apiService.delete('${ApiConfig.appointmentDetail}$id/');
      
      _appointments.removeWhere((a) => a['id'] == id);
      if (_appointment?['id'] == id) {
        _appointment = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer les rendez-vous d'un patient
  Future<void> getPatientAppointments(int patientId) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.appointments,
        queryParameters: {'patient': patientId},
      );
      
      _appointments = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer les rendez-vous d'un professionnel
  Future<void> getProfessionalAppointments(int professionalId) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.appointments,
        queryParameters: {'professional': professionalId},
      );
      
      _appointments = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par statut
  Future<void> filterByStatus(String status) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.appointments,
        queryParameters: {'status': status},
      );
      
      _appointments = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filtrer par date
  Future<void> filterByDate(String date) async {
    _setLoading(true);
    _clearError();

    try {
      final apiService = ApiService();
      final response = await apiService.get(
        ApiConfig.appointments,
        queryParameters: {'date': date},
      );
      
      _appointments = List<Map<String, dynamic>>.from(response.data['results'] ?? response.data);
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

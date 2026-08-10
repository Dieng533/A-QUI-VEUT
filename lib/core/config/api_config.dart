class ApiConfig {
  // Configuration de l'API
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // Endpoints d'authentification
  static const String login = '$baseUrl/auth/login/';
  static const String register = '$baseUrl/auth/register/';
  static const String profile = '$baseUrl/auth/profile/';
  static const String stats = '$baseUrl/auth/stats/';
  
  // Endpoints des professionnels
  static const String professionals = '$baseUrl/professionals/';
  static const String professionalDetail = '$baseUrl/professionals/';
  static const String professionalCreate = '$baseUrl/professionals/create/';
  static const String professionalUpdate = '$baseUrl/professionals/';
  static const String professionalDelete = '$baseUrl/professionals/';
  static const String professionalDashboard = '$baseUrl/professionals/dashboard/';
  
  // Endpoints des disponibilités
  static const String availabilityList = '$baseUrl/professionals/';
  static const String availabilityCreate = '$baseUrl/professionals/disponibilites/create/';
  
  // Endpoints des rendez-vous
  static const String appointments = '$baseUrl/appointments/';
  static const String appointmentDetail = '$baseUrl/appointments/';
  static const String appointmentCreate = '$baseUrl/appointments/create/';
  
  // Endpoints des lieux
  static const String locations = '$baseUrl/locations/';
  static const String locationDetail = '$baseUrl/locations/';
  static const String locationCreate = '$baseUrl/locations/create/';
  static const String locationUpdate = '$baseUrl/locations/';
  static const String locationDelete = '$baseUrl/locations/';
  
  // Token refresh
  static const String tokenRefresh = '$baseUrl/token/refresh/';
  
  // Durée du timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers par défaut
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers avec authentification
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}

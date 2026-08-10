import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  late Dio _dio;
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() => _instance;
  ApiService._internal() {
    _initDio();
  }
  
  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: ApiConfig.defaultHeaders,
    ));
    
    // Interceptor pour ajouter le token JWT
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        handler.next(options);
      },
      onError: (error, handler) async {
        // Gérer le rafraîchissement du token
        if (error.response?.statusCode == 401) {
          try {
            await _refreshToken();
            // Réessayer la requête originale
            final prefs = await SharedPreferences.getInstance();
            final newToken = prefs.getString('access_token');
            
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          } catch (e) {
            // Échec du rafraîchissement, déconnexion
            await _logout();
          }
        }
        handler.next(error);
      },
    ));
  }
  
  Future<Response<dynamic>> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    
    if (refreshToken == null) {
      throw Exception('No refresh token');
    }
    
    final response = await Dio().post(
      ApiConfig.tokenRefresh,
      data: {'refresh': refreshToken},
    );
    
    final newAccessToken = response.data['access'];
    await prefs.setString('access_token', newAccessToken);
    
    return response;
  }
  
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
  
  // Méthodes HTTP génériques
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Upload de fichier
  Future<Response<dynamic>> upload(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        'file': await MultipartFile.fromFile(filePath),
      });
      
      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Délai de connexion dépassé');
        case DioExceptionType.sendTimeout:
          return Exception('Délai d\'envoi dépassé');
        case DioExceptionType.receiveTimeout:
          return Exception('Délai de réception dépassé');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 
                        error.response?.data?['error'] ?? 
                        'Erreur serveur';
          
          switch (statusCode) {
            case 400:
              return Exception('Requête invalide: $message');
            case 401:
              return Exception('Non autorisé: $message');
            case 403:
              return Exception('Accès interdit: $message');
            case 404:
              return Exception('Ressource non trouvée: $message');
            case 500:
              return Exception('Erreur serveur: $message');
            default:
              return Exception('Erreur HTTP $statusCode: $message');
          }
        case DioExceptionType.cancel:
          return Exception('Requête annulée');
        case DioExceptionType.unknown:
          return Exception('Erreur réseau: ${error.message}');
        default:
          return Exception('Erreur inconnue: ${error.message}');
      }
    }
    return Exception('Erreur inconnue: $error');
  }
}

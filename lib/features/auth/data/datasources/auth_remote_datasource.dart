import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<AuthResponseModel> login({
    required String email, 
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email, 
          'password': password,
        },
      );

    
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      
      if (e.response?.statusCode == 401) {
        throw Exception('Identifiants invalides');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Votre compte est suspendu ou verrouillé');
      } else if (e.type == DioExceptionType.connectionError ||
                 e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Erreur de connexion au serveur (Vérifiez votre API)');
      } else {
        throw Exception(e.response?.data['message'] ?? 'Une erreur s\'est produite');
      }
    } catch (e) {
      throw Exception('Une erreur inattendue est survenue');
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.logout,
        data: {'refresh_token': refreshToken},
      );
    } catch (e) {
  
    }
  }
}
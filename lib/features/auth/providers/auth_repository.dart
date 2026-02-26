import 'package:dio/dio.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/core/constants/app_constants.dart';
import 'package:parcello_mobile/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResult> login(String identifier) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'identifier': identifier},
      );
      
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        return AuthResult(
          success: false, 
          message: 'Format de réponse invalide du serveur.'
        );
      }

      return AuthResult(
        success: true,
        requiresSetup: data['requiresSetup'] == true,
        totpSecret: data['totpSecret']?.toString(),
        message: data['message']?.toString(),
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Erreur de connexion (${e.type})';
      if (errorData is Map<String, dynamic>) {
        message = errorData['error'] ?? errorData['message'] ?? message;
      } else if (errorData is String && errorData.isNotEmpty) {
        message = errorData;
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Une erreur inattendue est survenue: $e',
      );
    }
  }

  Future<AuthVerifyResult> verify2FA(String identifier, String token) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/verify-2fa',
        data: {'identifier': identifier, 'token': token},
      );
      
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        return AuthVerifyResult(
          success: false, 
          message: 'Format de réponse invalide lors de la vérification.'
        );
      }

      return AuthVerifyResult(
        success: true,
        token: data['token']?.toString(),
        user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
      );
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = 'Code invalide';
      if (errorData is Map<String, dynamic>) {
        message = errorData['error'] ?? errorData['message'] ?? message;
      }
      return AuthVerifyResult(success: false, message: message);
    } catch (e) {
      return AuthVerifyResult(
        success: false,
        message: 'Erreur de vérification: $e',
      );
    }
  }
}

class AuthResult {
  final bool success;
  final bool requiresSetup;
  final String? totpSecret;
  final String? message;

  AuthResult({required this.success, this.requiresSetup = false, this.totpSecret, this.message});
}

class AuthVerifyResult {
  final bool success;
  final String? token;
  final UserModel? user;
  final String? message;

  AuthVerifyResult({required this.success, this.token, this.user, this.message});
}

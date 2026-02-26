import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/constants/app_constants.dart';
import '../../../models/user_model.dart';

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
      return AuthResult(
        success: true,
        requiresSetup: data['requiresSetup'] ?? false,
        totpSecret: data['totpSecret'],
        message: data['message'],
      );
    } on DioException catch (e) {
      return AuthResult(
        success: false,
        message: e.response?.data['error'] ?? 'Erreur de connexion',
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
      return AuthVerifyResult(
        success: true,
        token: data['token'],
        user: UserModel.fromJson(data['user']),
      );
    } on DioException catch (e) {
      return AuthVerifyResult(
        success: false,
        message: e.response?.data['error'] ?? 'Code invalide',
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

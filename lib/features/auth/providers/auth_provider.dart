import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/user_model.dart';
import 'auth_repository.dart';


final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? token;
  final String? error;
  final bool requires2FA;
  final bool requiresSetup;
  final String? totpSecret;
  final String? identifier;

  AuthState({
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
    this.requires2FA = false,
    this.requiresSetup = false,
    this.totpSecret,
    this.identifier,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? token,
    String? error,
    bool? requires2FA,
    bool? requiresSetup,
    String? totpSecret,
    String? identifier,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error, // Can be null to clear error
      requires2FA: requires2FA ?? this.requires2FA,
      requiresSetup: requiresSetup ?? this.requiresSetup,
      totpSecret: totpSecret ?? this.totpSecret,
      identifier: identifier ?? this.identifier,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._repository) : super(AuthState());

  Future<void> login(String identifier) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final result = await _repository.login(identifier);
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          requires2FA: true,
          requiresSetup: result.requiresSetup,
          totpSecret: result.totpSecret,
          identifier: identifier,
        );
      } else {
        state = state.copyWith(isLoading: false, error: result.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Une erreur critique est survenue: $e');
    }
  }

  Future<bool> verify2FA(String token) async {
    if (state.identifier == null) return false;
    
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _repository.verify2FA(state.identifier!, token);
    
    if (result.success && result.token != null) {
      // Save token and user
      await _storage.write(key: AppConstants.tokenKey, value: result.token);
      
      state = state.copyWith(
        isLoading: false,
        token: result.token,
        user: result.user,
        requires2FA: false,
      );
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: result.message);
      return false;
    }
  }

  void reset() {
    state = AuthState();
  }
}

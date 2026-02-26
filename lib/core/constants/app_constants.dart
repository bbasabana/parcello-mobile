class AppConstants {
  static const String appName = 'Parcello';
  
  // API URL from user request
  static const String baseUrl = 'https://kinshasa.vercel.app';
  static const String apiUrl = '$baseUrl/api';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isTotpEnabledKey = 'is_totp_enabled';

  // Design Tokens
  static const double horizontalPadding = 20.0;
  static const double borderRadius = 16.0;
}

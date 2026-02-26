import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/api/api_client.dart';
import 'features/auth/screens/login_screen.dart';

import 'core/services/sync_service.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();

  // Initialize SyncService
  final syncService = SyncService(container.read(apiClientProvider));
  syncService.start();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ParcelloApp(),
    ),
  );
}

class ParcelloApp extends StatelessWidget {
  const ParcelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

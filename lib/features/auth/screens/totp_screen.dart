import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class TotpScreen extends ConsumerStatefulWidget {
  const TotpScreen({super.key});

  @override
  ConsumerState<TotpScreen> createState() => _TotpScreenState();
}

class _TotpScreenState extends ConsumerState<TotpScreen> {
  final _codeController = TextEditingController();

  void _handleVerify() async {
    final code = _codeController.text.trim();
    if (code.length == 6) {
      final success = await ref.read(authStateProvider.notifier).verify2FA(code);
      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sécurité 2FA'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.horizontalPadding * 1.5),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.shieldCheck,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Vérification double facteur',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              authState.requiresSetup 
                ? 'Veuillez scanner le code QR ou entrer la clé secrète dans votre application d\'authentification (Google Authenticator).'
                : 'Entrez le code à 6 chiffres généré par votre application d\'authentification.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (authState.requiresSetup && authState.totpSecret != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSlate,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.slate.shade200),
                ),
                child: Column(
                  children: [
                    const Text('Votre clé secrète :'),
                    const SizedBox(height: 8),
                    SelectableText(
                      authState.totpSecret!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 48),
            // Code Input
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 20,
              ),
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.slate.shade200, width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 3),
                ),
              ),
              onChanged: (val) {
                if (val.length == 6) _handleVerify();
              },
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: authState.isLoading ? null : _handleVerify,
              child: authState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Vérifier'),
            ),
          ],
        ),
      ),
    );
  }
}

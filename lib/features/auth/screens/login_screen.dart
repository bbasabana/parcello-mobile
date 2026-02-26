import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'totp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authStateProvider.notifier).login(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to navigate
    ref.listen(authStateProvider, (previous, next) {
      if (next.requires2FA && !next.isLoading) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TotpScreen()),
        );
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppTheme.errorRed),
        );
      }
    });

    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppTheme.primaryBlue,
          image: DecorationImage(
            image: AssetImage('assets/images/pattern.png'), // Optional background pattern
            opacity: 0.05,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Logo & Title
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Image.asset(
                      'assets/logos/armorie.png',
                      height: 64,
                      width: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Parcello',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Système de Recensement Urbain',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Login Form
              Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connexion',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Entrez votre identifiant professionnel pour continuer.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email ou Téléphone',
                          prefixIcon: Icon(LucideIcons.mail, size: 20),
                        ),
                        validator: (value) => 
                          (value == null || value.isEmpty) ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        child: authState.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Continuer'),
                                  SizedBox(width: 8),
                                  Icon(LucideIcons.arrowRight, size: 20),
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () {}, // Link to help if needed
                          child: const Text('Besoin d\'aide pour vous connecter ?'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

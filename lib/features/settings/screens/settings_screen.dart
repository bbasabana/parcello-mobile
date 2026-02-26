import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';
import 'package:parcello_mobile/features/auth/providers/auth_provider.dart';
import 'package:parcello_mobile/features/auth/screens/login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUserHeader(user),
          const SizedBox(height: 32),
          _buildSectionTitle('Compte'),
          _buildSettingsItem(LucideIcons.user, 'Profil', 'Gérer vos informations personnelles'),
          _buildSettingsItem(LucideIcons.shieldCheck, 'Sécurité', 'Mot de passe et 2FA'),
          _buildSettingsItem(LucideIcons.bell, 'Notifications', 'Préférences de rappel'),
          const SizedBox(height: 24),
          _buildSectionTitle('Préférences'),
          _buildSettingsItem(LucideIcons.languages, 'Langue', 'Français (Congo)'),
          _buildSettingsItem(LucideIcons.moon, 'Mode Sombre', 'Système'),
          const SizedBox(height: 24),
          _buildSectionTitle('Support'),
          _buildSettingsItem(LucideIcons.helpCircle, 'Aide & Support', 'Contactez-nous'),
          _buildSettingsItem(LucideIcons.info, 'À propos', 'Version 1.0.0'),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(authStateProvider.notifier).reset();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(LucideIcons.logOut),
            label: const Text('Déconnexion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryBlue,
            child: Text(
              user?.name?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Utilisateur',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user?.role ?? 'Agent',
                    style: const TextStyle(color: Color(0xFF92400E), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textLight, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppTheme.textLight),
        onTap: () {},
      ),
    );
  }
}

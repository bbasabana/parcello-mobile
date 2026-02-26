import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAPA Data'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSyncStatusCard(),
          const SizedBox(height: 24),
          const Text(
            'Données Locales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDataItem('Fiches en attente', '0', LucideIcons.uploadCloud, Colors.blue),
          _buildDataItem('Fiches synchronisées', '12', LucideIcons.checkCircle2, Colors.green),
          _buildDataItem('Dernier cache', 'Il y a 5 min', LucideIcons.database, Colors.orange),
          const SizedBox(height: 24),
          const Text(
            'Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActionItem(context, 'Forcer la synchronisation', LucideIcons.refreshCw, () {}),
          _buildActionItem(context, 'Vider le cache local', LucideIcons.trash2, () {}, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.cloudCheck, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Système Synchronisé',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Toutes vos fiches locales ont été transmises au serveur central.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontWeight: FontWeight.medium)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String label, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: isDestructive ? Colors.red : AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDestructive ? Colors.red : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

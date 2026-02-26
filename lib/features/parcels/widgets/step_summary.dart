import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';

class StepSummary extends ConsumerWidget {
  const StepSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parcelFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Récapitulatif Final',
            'Veuillez vérifier les informations avant l\'envoi.',
            LucideIcons.checkCheck,
          ),
          const SizedBox(height: 32),
          _buildSection('Localisation', [
            'Commune: ${state.commune ?? '-'}',
            'Quartier: ${state.quarter ?? '-'}',
            'Position: ${state.latitude?.toStringAsFixed(4)}, ${state.longitude?.toStringAsFixed(4)}',
          ]),
          const SizedBox(height: 24),
          _buildSection('Détails', [
            'Type: ${state.type ?? '-'}',
            'Superficie: ${state.area ?? '-'} m²',
          ]),
          const SizedBox(height: 24),
          _buildSection('Propriétaire', [
            'Nom: ${state.ownerData['lastName'] ?? '-'} ${state.ownerData['firstName'] ?? '-'}',
            'Pièce ID: ${state.ownerData['idCardNumber'] ?? '-'}',
          ]),
          const SizedBox(height: 24),
          _buildSection('Contenu', [
            'Unités: ${state.apartments.length}',
            'Total Résidents: ${state.apartments.fold(0, (sum, apt) => sum + apt.residents.length)}',
          ]),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'En cliquant sur "Terminer", les données seront transmises au serveur.',
                    style: TextStyle(fontSize: 13, color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(item, style: const TextStyle(color: AppTheme.textLight)),
        )),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

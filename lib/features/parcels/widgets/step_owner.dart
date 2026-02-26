import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';

class StepOwner extends ConsumerWidget {
  const StepOwner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parcelFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Informations du Propriétaire',
            'Identifiez le détenteur principal de la parcelle.',
            LucideIcons.user,
          ),
          const SizedBox(height: 32),
          const Text('Type de détenteur', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildChoiceChip(ref, 'PHYSICAL', 'Physique', state.ownerData['type'] == 'PHYSICAL'),
              const SizedBox(width: 12),
              _buildChoiceChip(ref, 'MORAL', 'Morale', state.ownerData['type'] == 'MORAL'),
            ],
          ),
          const SizedBox(height: 32),
          _buildTextField('Nom', ref, 'lastName'),
          const SizedBox(height: 16),
          _buildTextField('Post-nom', ref, 'postName'),
          const SizedBox(height: 16),
          _buildTextField('Prénom', ref, 'firstName'),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          const Text('Pièce d\'identité', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTextField('N° de la pièce', ref, 'idCardNumber'),
          const SizedBox(height: 16),
          _buildTextField('Profession', ref, 'profession'),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(WidgetRef ref, String val, String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => ref.read(parcelFormProvider.notifier).updateOwner({'type': val}),
      selectedColor: AppTheme.primaryBlue.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTextField(String label, WidgetRef ref, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppTheme.textLight)),
        const SizedBox(height: 8),
        TextField(
          onChanged: (val) => ref.read(parcelFormProvider.notifier).updateOwner({key: val}),
          decoration: InputDecoration(
            hintText: 'Saisissez le $label',
          ),
        ),
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

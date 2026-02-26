import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';

class StepDetails extends ConsumerWidget {
  const StepDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parcelFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Type de Parcelle',
            'Saisissez les caractéristiques principales de la parcelle.',
            LucideIcons.home,
          ),
          const SizedBox(height: 32),
          _buildTypeOption(ref, 'RESIDENTIAL', 'Résidentiel', LucideIcons.home, state.type == 'RESIDENTIAL'),
          const SizedBox(height: 12),
          _buildTypeOption(ref, 'COMMERCIAL', 'Commercial', LucideIcons.briefcase, state.type == 'COMMERCIAL'),
          const SizedBox(height: 12),
          _buildTypeOption(ref, 'RELIGIOUS', 'Confessionnel', LucideIcons.building, state.type == 'RELIGIOUS'),
          const SizedBox(height: 12),
          _buildTypeOption(ref, 'MIXED', 'Mixte', LucideIcons.layoutGrid, state.type == 'MIXED'),
          const SizedBox(height: 32),
          const Text('Superficie (m²)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Ex: 450',
              suffixText: 'm²',
            ),
            onChanged: (val) {
              // Update area in state
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(WidgetRef ref, String val, String label, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () => ref.read(parcelFormProvider.notifier).setType(val),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.slate.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryBlue : AppTheme.textLight),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
              ),
            ),
            const Spacer(),
            if (isSelected) const Icon(LucideIcons.checkCircle2, color: AppTheme.primaryBlue, size: 20),
          ],
        ),
      ),
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

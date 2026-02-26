import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
          if (state.type == 'MIXED') ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Types inclus (min. 2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textLight)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMixedTypeChip(ref, state.mixedTypes, 'RESIDENTIAL', 'Résidentiel', LucideIcons.home),
                      _buildMixedTypeChip(ref, state.mixedTypes, 'COMMERCIAL', 'Commercial', LucideIcons.briefcase),
                      _buildMixedTypeChip(ref, state.mixedTypes, 'RELIGIOUS', 'Confessionnel', LucideIcons.building),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
            color: isSelected ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
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

  Widget _buildMixedTypeChip(WidgetRef ref, List<String> currentTypes, String val, String label, IconData icon) {
    final isSelected = currentTypes.contains(val);
    return InkWell(
      onTap: () => ref.read(parcelFormProvider.notifier).toggleMixedType(val),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppTheme.textLight),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppTheme.textDark,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(LucideIcons.check, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

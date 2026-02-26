import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/location_service.dart';
import '../providers/parcel_form_provider.dart';

class StepLocation extends ConsumerStatefulWidget {
  const StepLocation({super.key});

  @override
  ConsumerState<StepLocation> createState() => _StepLocationState();
}

class _StepLocationState extends ConsumerState<StepLocation> {
  bool _isLocating = false;

  void _getCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final position = await LocationService().getCurrentLocation();
      if (position != null) {
        ref.read(parcelFormProvider.notifier).updateLocation(
          lat: position.latitude,
          lng: position.longitude,
          address: 'Localisation capturée via GPS',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.errorRed),
      );
    } finally {
      setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parcelFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Localisation Administrative',
            'Définissez la zone géographique de la parcelle.',
            LucideIcons.building2,
          ),
          const SizedBox(height: 24),
          // Commune & Quartier (Selectors)
          const Text('Commune', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDropdown(['Gombe', 'Kintambo', 'Lingwala'], state.commune, (val) {
            ref.read(parcelFormProvider.notifier).updateLocation(commune: val);
          }),
          const SizedBox(height: 16),
          const Text('Quartier', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDropdown(['Quartier Fleuve', 'Quartier Gare'], state.quarter, (val) {
            ref.read(parcelFormProvider.notifier).updateLocation(quarter: val);
          }),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Coordonnées GPS',
            'Capturez les coordonnées exactes de la parcelle.',
            LucideIcons.navigation,
          ),
          const SizedBox(height: 20),
          if (state.latitude != null && state.longitude != null)
             Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Position capturée', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      Text('${state.latitude!.toStringAsFixed(6)}, ${state.longitude!.toStringAsFixed(6)}', style: const TextStyle(fontFamily: 'monospace')),
                    ],
                  ),
                ],
              ),
            )
          else
            const Center(child: Text('Aucune coordonnée capturée', style: TextStyle(color: AppTheme.textLight))),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _isLocating ? null : _getCurrentLocation,
            icon: _isLocating 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(LucideIcons.mapPin),
            label: Text(_isLocating ? 'Localisation en cours...' : 'Capturer ma position actuelle'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
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

  Widget _buildDropdown(List<String> items, String? current, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.slate.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          hint: const Text('Sélectionner'),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

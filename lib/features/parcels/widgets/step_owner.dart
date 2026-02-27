import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Type de pièce', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppTheme.textLight)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: state.ownerData['idCardType'],
                items: const [
                  DropdownMenuItem(value: "CARTE D'ÉLECTEUR", child: Text("Carte d'électeur")),
                  DropdownMenuItem(value: "PASSEPORT", child: Text("Passeport")),
                  DropdownMenuItem(value: "PERMIS DE CONDUIRE", child: Text("Permis de conduire")),
                  DropdownMenuItem(value: "CARTE DE LA POLICE", child: Text("Carte de la police")),
                  DropdownMenuItem(value: "AUTRES", child: Text("Autres")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    ref.read(parcelFormProvider.notifier).updateOwner({'idCardType': val});
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Sélectionner le type',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('N° de la pièce', ref, 'idCardNumber'),
          const SizedBox(height: 24),
          if (state.ownerData['idCardType'] != null) ...[
            const Text('Document d\'identité', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textLight)),
            const SizedBox(height: 12),
            _buildImagePicker(ref, state.idCardPhoto),
          ],
          const SizedBox(height: 24),
          _buildTextField('Profession', ref, 'profession'),
        ],
      ),
    );
  }

  Widget _buildImagePicker(WidgetRef ref, String? imagePath) {
    return InkWell(
      onTap: () async {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          ref.read(parcelFormProvider.notifier).addPhoto('idCardPhoto', image.path);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.slate[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
        ),
        child: imagePath != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(imagePath), width: double.infinity, height: 160, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(LucideIcons.refreshCw, color: Colors.white, size: 18),
                        onPressed: () {}, // Handled by InkWell onTap
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.camera, color: AppTheme.primaryBlue.withOpacity(0.5), size: 32),
                  const SizedBox(height: 12),
                  const Text('Prendre en photo la pièce', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                ],
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';

class StepUploads extends ConsumerStatefulWidget {
  const StepUploads({super.key});

  @override
  ConsumerState<StepUploads> createState() => _StepUploadsState();
}

class _StepUploadsState extends ConsumerState<StepUploads> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70, // Moderate compression
    );

    if (image != null) {
      // Logic to add photo path to state
      // ref.read(parcelFormProvider.notifier).addPhoto(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Documents & Photos',
            'Ajoutez des preuves visuelles de la parcelle et des documents.',
            LucideIcons.camera,
          ),
          const SizedBox(height: 32),
          _buildUploadSection('Photo de la Parcelle', LucideIcons.building2),
          const SizedBox(height: 24),
          _buildUploadSection('Documents (Contrat, ID)', LucideIcons.fileText),
          const SizedBox(height: 24),
          _buildUploadSection('Photo du Propriétaire', LucideIcons.userCircle),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.slate.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.slate.shade200, style: BorderStyle.solid),
          ),
          child: InkWell(
            onTap: () => _pickImage(ImageSource.camera),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, color: Colors.slate.shade400),
                const SizedBox(height: 8),
                Text('Prendre une photo', style: TextStyle(color: Colors.slate.shade500, fontSize: 13)),
              ],
            ),
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

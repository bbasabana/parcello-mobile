import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

  Future<void> _pickImage(ImageSource source, String type) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70, // Moderate compression
    );

    if (image != null) {
      ref.read(parcelFormProvider.notifier).addPhoto(type, image.path);
    }
  }

  void _showPickerOptions(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(LucideIcons.camera),
                title: const Text('Prendre une photo'),
                onTap: () {
                  _pickImage(ImageSource.camera, type);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  _pickImage(ImageSource.gallery, type);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
            'Documents & Photos',
            'Ajoutez des preuves visuelles de la parcelle et des documents.',
            LucideIcons.camera,
          ),
          const SizedBox(height: 32),
          _buildUploadSection('Photo de la Parcelle', LucideIcons.building2, 'mapPhoto', state.mapPhoto, state),
          const SizedBox(height: 24),
          _buildUploadSection('Photo du Propriétaire', LucideIcons.userCircle, 'parcelPhoto', state.parcelPhoto, state),
          const SizedBox(height: 24),
          _buildUploadSection('Pièce d\'identité', LucideIcons.fileText, 'idCardPhoto', state.idCardPhoto, state),
        ],
      ),
    );
  }

  Widget _buildUploadSection(String label, IconData icon, String type, String? imagePath, ParcelFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: imagePath != null ? Colors.transparent : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: imagePath != null ? AppTheme.primaryBlue : const Color(0xFFE2E8F0), 
              style: BorderStyle.solid,
              width: imagePath != null ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => _showPickerOptions(context, type),
            borderRadius: BorderRadius.circular(16),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        imagePath.startsWith('http') 
                          ? Image.network(imagePath, fit: BoxFit.cover)
                          : Image.file(File(imagePath), fit: BoxFit.cover),
                        if (state.uploadingPhotos[type] == true)
                          Container(
                            color: Colors.black26,
                            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                          ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              state.uploadingPhotos[type] == true ? LucideIcons.loader2 : LucideIcons.edit2, 
                              color: Colors.white, 
                              size: 16
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: const Color(0xFF94A3B8), size: 32),
                      const SizedBox(height: 12),
                      const Text('Appuyez pour ajouter', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      const Text('PNG ou JPG (max. 5MB)', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';

class StepResidents extends ConsumerWidget {
  const StepResidents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parcelFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Unités & Résidents',
            'Recensez les occupants pour chaque unité créée.',
            LucideIcons.users,
          ),
          const SizedBox(height: 24),
          if (state.apartments.isEmpty)
            _buildEmptyState(ref)
          else
            Column(
              children: [
                ...state.apartments.asMap().entries.map((entry) {
                  return _buildApartmentCard(context, ref, entry.key, entry.value);
                }),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _showAddApartmentDialog(context, ref),
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('Ajouter une unité'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(LucideIcons.home, size: 48, color: Colors.slate.shade300),
          const SizedBox(height: 16),
          const Text('Aucune unité configurée', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Commencez par ajouter un appartement ou un local.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textLight)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddApartmentDialog(ref.context, ref),
            icon: const Icon(LucideIcons.plus),
            label: const Text('Générer les unités'),
          ),
        ],
      ),
    );
  }

  Widget _buildApartmentCard(BuildContext context, WidgetRef ref, int index, Apartment apartment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.home, color: AppTheme.primaryBlue, size: 20),
        ),
        title: Text(apartment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${apartment.residents.length} résident(s)'),
        trailing: IconButton(
          icon: const Icon(LucideIcons.trash2, color: AppTheme.errorRed, size: 20),
          onPressed: () => ref.read(parcelFormProvider.notifier).removeApartment(index),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...apartment.residents.asMap().entries.map((resEntry) {
                   final resident = resEntry.value;
                   return ListTile(
                     contentPadding: EdgeInsets.zero,
                     leading: const CircleAvatar(child: Icon(LucideIcons.user, size: 16)),
                     title: Text('${resident.firstName} ${resident.lastName}'),
                     subtitle: Text(resident.role),
                     trailing: IconButton(
                       icon: const Icon(LucideIcons.minusCircle, color: Colors.slate),
                       onPressed: () => ref.read(parcelFormProvider.notifier).removeResident(index, resEntry.key),
                     ),
                   );
                }),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => _showAddResidentDialog(context, ref, index),
                  icon: const Icon(LucideIcons.userPlus, size: 18),
                  label: const Text('Ajouter un résident'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddApartmentDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: 'Unité ${ref.read(parcelFormProvider).apartments.length + 1}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle Unité'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nom de l\'unité'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              ref.read(parcelFormProvider.notifier).addApartment(nameController.text, 'RESIDENTIAL');
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddResidentDialog(BuildContext context, WidgetRef ref, int aptIndex) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un Résident'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 12),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Nom')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              ref.read(parcelFormProvider.notifier).addResident(
                aptIndex,
                Resident(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  sex: 'M',
                  role: 'Résident',
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
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
}

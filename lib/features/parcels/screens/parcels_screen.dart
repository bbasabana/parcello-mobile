import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';
import 'package:parcello_mobile/features/parcels/providers/parcel_repository.dart';
import 'package:parcello_mobile/models/parcel_model.dart';
import 'package:intl/intl.dart';
import 'parcel_detail_screen.dart';

class ParcelsScreen extends ConsumerWidget {
  const ParcelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcelsAsync = ref.watch(userParcelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Parcelles'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(userParcelsProvider.future),
        child: parcelsAsync.when(
          data: (parcels) => parcels.isEmpty 
            ? _buildEmptyState()
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: parcels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _buildParcelCard(context, parcels[index]),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erreur: $err')),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.building, size: 64, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Aucune parcelle trouvée', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildParcelCard(BuildContext context, ParcelModel parcel) {
    final dateStr = DateFormat('dd/MM/yyyy').format(parcel.createdAt);
    
    Color statusColor = Colors.grey;
    String statusLabel = 'En attente';
    if (parcel.status == 'APPROVED') {
      statusColor = Colors.green;
      statusLabel = 'Approuvé';
    } else if (parcel.status == 'REJECTED') {
      statusColor = Colors.red;
      statusLabel = 'Rejeté';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParcelDetailScreen(parcel: parcel),
        ),
      ),
      child: Card(
        child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(LucideIcons.home, color: AppTheme.primaryBlue),
        ),
        title: Text(
          parcel.ownerName ?? 'Propriétaire Inconnu',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${parcel.commune} • ${parcel.quarter}'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(LucideIcons.calendar, size: 14, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Text(dateStr, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(LucideIcons.mapPin, size: 14, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Expanded(child: Text(parcel.address, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(parcel.fileNumber ?? '', style: const TextStyle(fontSize: 10, color: AppTheme.textLight)),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

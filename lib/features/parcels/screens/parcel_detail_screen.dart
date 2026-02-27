import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';
import 'package:parcello_mobile/models/parcel_model.dart';
import 'package:intl/intl.dart';

class ParcelDetailScreen extends StatelessWidget {
  final ParcelModel parcel;

  const ParcelDetailScreen({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').format(parcel.createdAt);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSlate,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(LucideIcons.fileText, 'Informations Générales'),
                  _buildInfoCard([
                    _buildInfoRow('Dossier No', parcel.fileNumber ?? 'N/A'),
                    _buildInfoRow('Type', _translateType(parcel.type ?? '')),
                    _buildInfoRow('Surface Area', '${parcel.surfaceArea ?? "N/A"} m²'),
                    _buildInfoRow('Date de création', dateStr),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle(LucideIcons.mapPin, 'Localisation'),
                  _buildInfoCard([
                    _buildInfoRow('Commune', parcel.commune),
                    _buildInfoRow('Quartier', parcel.quarter),
                    _buildInfoRow('Adresse', parcel.address),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle(LucideIcons.user, 'Propriétaire'),
                  _buildInfoCard([
                    _buildInfoRow('Nom complet', parcel.ownerName ?? 'N/A'),
                    _buildInfoRow('Détenteur', 'Physique'), // Mocked for now
                  ]),
                  const SizedBox(height: 100), // Spacer for bottom
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(LucideIcons.edit2, color: Colors.white),
        label: const Text('Modifier', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryBlue,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Détails Parcelle',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(color: AppTheme.primaryBlue),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor = Colors.amber;
    String statusText = 'EN ATTENTE';
    
    if (parcel.status == 'APPROVED') {
      statusColor = AppTheme.successGreen;
      statusText = 'APPROUVÉ';
    } else if (parcel.status == 'REJECTED') {
      statusColor = AppTheme.errorRed;
      statusText = 'REJETÉ';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.shieldCheck, color: statusColor),
          const SizedBox(width: 12),
          Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const Spacer(),
          const Text('Vérifié par Admin', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppTheme.textLight,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textLight)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
            ),
          ),
        ],
      ),
    );
  }

  String _translateType(String type) {
    switch (type) {
      case 'RESIDENTIAL': return 'Résidentiel';
      case 'COMMERCIAL': return 'Commercial';
      case 'MIXED': return 'Mixte';
      case 'RELIGIOUS': return 'Confessionnel';
      default: return type;
    }
  }
}

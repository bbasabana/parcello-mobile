import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';
import 'package:parcello_mobile/features/auth/providers/auth_provider.dart';
import 'package:parcello_mobile/features/auth/screens/login_screen.dart';
import 'package:parcello_mobile/features/parcels/screens/new_parcel_screen.dart';
import 'package:parcello_mobile/features/dashboard/providers/stats_repository.dart';
import 'package:parcello_mobile/features/parcels/providers/parcel_form_provider.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/models/stats_model.dart';
import 'package:parcello_mobile/features/parcels/screens/parcels_screen.dart';
import 'package:parcello_mobile/features/map/screens/map_screen.dart';
import 'package:parcello_mobile/features/data/screens/data_screen.dart';
import 'package:parcello_mobile/features/reports/screens/reports_screen.dart';
import 'package:parcello_mobile/features/settings/screens/settings_screen.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logos/armorie.png', height: 36),
            const SizedBox(width: 12),
            const Text('Parcello', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(statsProvider.future),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.horizontalPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(user),
              const SizedBox(height: 24),
              Text(
                'Vue d\'ensemble',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              statsAsync.when(
                data: (stats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(stats),
                    const SizedBox(height: 32),
                    _buildRecentActivityHeader(),
                    const SizedBox(height: 16),
                    _buildRecentParcelsList(stats.recentParcels),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Erreur: $err')),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewParcelScreen()),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        icon: Icon(LucideIcons.plus),
        label: const Text('Nouvelle Parcelle'),
      ),
    );
  }

  Widget _buildWelcomeHeader(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour, ${user?.name ?? 'Chargement...'}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          'Chef de quartier : ${user?.commune ?? 'Kinshasa'}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard('Parcelles', stats.totalParcels.toString(), LucideIcons.building2, Colors.blue),
        _buildStatCard('Propriétaires', stats.totalOwners.toString(), LucideIcons.user, Colors.orange),
        _buildStatCard('Résidents', stats.totalResidents.toString(), LucideIcons.users, Colors.green),
        _buildStatCard('Recensement', '85%', LucideIcons.barChart3, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dernières fiches',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Voir tout'),
        ),
      ],
    );
  }

  Widget _buildRecentParcelsList(List<dynamic> recentParcels) {
    if (recentParcels.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Aucune activité récente', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentParcels.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final parcel = recentParcels[index];
        final ownerName = parcel['owner'] != null ? parcel['owner']['fullName'] : 'Inconnu';
        
        // Define status color and label
        Color statusColor = Colors.grey;
        String statusLabel = 'Inconnu';
        if (parcel['status'] == 'APPROVED') {
          statusColor = Colors.green;
          statusLabel = 'Approuvé';
        } else if (parcel['status'] == 'PENDING') {
          statusColor = Colors.orange;
          statusLabel = 'En attente';
        } else if (parcel['status'] == 'REJECTED') {
          statusColor = Colors.red;
          statusLabel = 'Rejeté';
        }

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFF8FAFC),
              child: Icon(LucideIcons.mapPin, color: AppTheme.primaryBlue, size: 20),
            ),
            title: Text(
              ownerName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${parcel['commune']} • ${parcel['quarter']}'),
            trailing: Container(
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
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
           UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryBlue),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logos/armorie.png'),
              ),
            ),
            accountName: Text(ref.watch(authStateProvider).user?.name ?? 'Utilisateur'),
            accountEmail: Text(ref.watch(authStateProvider).user?.email ?? ''),
          ),
          _buildDrawerItem(LucideIcons.layoutDashboard, 'Tableau de bord', true, onTap: () => Navigator.of(context).pop()),
          _buildDrawerItem(LucideIcons.building, 'Mes Parcelles', false, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ParcelsScreen()));
          }),
          _buildDrawerItem(LucideIcons.map, 'Cartographie', false, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapScreen()));
          }),
          _buildDrawerItem(LucideIcons.database, 'MAPA Data', false, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DataScreen()));
          }),
          _buildDrawerItem(LucideIcons.pieChart, 'Rapports', false, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportsScreen()));
          }),
          const Divider(),
          _buildDrawerItem(LucideIcons.settings, 'Paramètres', false, onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          const Spacer(),
          _buildDrawerItem(LucideIcons.logOut, 'Déconnexion', false, onTap: () {
            ref.read(authStateProvider.notifier).reset();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppTheme.primaryBlue : AppTheme.textLight, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap ?? () {},
    );
  }
}

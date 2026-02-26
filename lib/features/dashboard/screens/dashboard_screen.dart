import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcello'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.horizontalPadding),
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
            _buildStatsGrid(),
            const SizedBox(height: 32),
            _buildRecentActivityHeader(),
            const SizedBox(height: 16),
            _buildRecentParcelsList(),
          ],
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
        icon: const Icon(LucideIcons.plus),
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

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard('Parcelles', '248', LucideIcons.building2, Colors.blue),
        _buildStatCard('Propriétaires', '192', LucideIcons.user, Colors.orange),
        _buildStatCard('Résidents', '1.2k', LucideIcons.users, Colors.green),
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
      mainAxisAlignment: MainAxisAlignment.between,
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

  Widget _buildRecentParcelsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppTheme.backgroundSlate,
              child: const Icon(LucideIcons.mapPin, color: AppTheme.primaryBlue, size: 20),
            ),
            title: Text(
              index == 0 ? 'Av. des Aviateurs, 45' : index == 1 ? 'Av. Lukusa, 12' : 'Av. de la Justice, 8',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Quartier Gombe • Il y a 2h'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, py: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Validé',
                style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
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
          _buildDrawerItem(LucideIcons.layoutDashboard, 'Tableau de bord', true),
          _buildDrawerItem(LucideIcons.building, 'Mes Parcelles', false),
          _buildDrawerItem(LucideIcons.map, 'Cartographie', false),
          _buildDrawerItem(LucideIcons.database, 'MAPA Data', false),
          _buildDrawerItem(LucideIcons.pieChart, 'Rapports', false),
          const Divider(),
          _buildDrawerItem(LucideIcons.settings, 'Paramètres', false),
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
import 'login_screen.dart'; // Added for logout navigation

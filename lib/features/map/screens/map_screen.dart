import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartographie'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          image: const DecorationImage(
            image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=-4.325,15.322&zoom=13&size=600x600&key=YOUR_API_KEY'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.map, size: 48, color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 32),
            const Text(
              'Vue Interactive Kinshasa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'La visualisation cartographique détaillée est en cours d\'intégration avec les données SIG de la ville.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textLight, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.layers),
              label: const Text('Changer de calque'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

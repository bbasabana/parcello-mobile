import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MAPA Data')),
      body: const Center(child: Text('Base de données MAPA en développement...')),
    );
  }
}

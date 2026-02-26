import 'package:flutter/material.dart';

class ParcelsScreen extends StatelessWidget {
  const ParcelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Parcelles')),
      body: const Center(child: Text('Liste des parcelles en développement...')),
    );
  }
}

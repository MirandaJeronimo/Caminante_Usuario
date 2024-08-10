import 'package:flutter/material.dart';

class ajusteCentroAyuda extends StatelessWidget {
  const ajusteCentroAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto de Perfil'),
      ),
      body: const Center(
        child: Text('Pantalla de Foto de Perfil'),
      ),
    );
  }
}
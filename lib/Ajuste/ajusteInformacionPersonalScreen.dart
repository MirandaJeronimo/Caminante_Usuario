import 'package:flutter/material.dart';

class ajusteInformacionPersonalScreen extends StatelessWidget {
  const ajusteInformacionPersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Personal'),
      ),
      body: const Center(
        child: Text('Pantalla de Información Personal'),
      ),
    );
  }
}
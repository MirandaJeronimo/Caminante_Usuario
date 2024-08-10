import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:caminante_appvsc/perfil.dart';
import 'package:caminante_appvsc/eventos.dart';
import 'package:caminante_appvsc/favoritos.dart';
import 'package:caminante_appvsc/ajustes.dart';
import 'package:caminante_appvsc/sites.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          color: HexColor('#FFFFFF'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(context, 'assets/perfil.png', const PerfilScreen(),isSelected: false),
              _buildIconButton(context, 'assets/calendario.png', const EventosScreen(),isSelected: false),
              _buildIconButton(context, 'assets/home.png', const SitesScreen(),isSelected: true),
              _buildIconButton( context, 'assets/favoritos.png', const FavoritosScreen(),isSelected: false),
              _buildIconButton(context, 'assets/ajustes.png', const AjustesScreen(),isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context,
      String imagePath,
      Widget screen, {
        required bool isSelected,
      }) {
    return SizedBox(
      width: 60.0,
      child: IconButton(
        onPressed: () {
          if (isSelected) {
            return; // Evitar navegar a la misma pantalla
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        icon: Image.asset(
          imagePath,
          width: 35.0,
          color: isSelected ? Colors.blue : null, // Color diferente si está seleccionado
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_color/flutter_color.dart';

class perfil_visitasScreen extends StatelessWidget {
  const perfil_visitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Visitas', style: GoogleFonts.montserrat(color: HexColor('#FF0080'))),
        backgroundColor: HexColor('#FFFFFF'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: HexColor('#FF0080')),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text(
          'Contenido de Mis Visitas',
          style: GoogleFonts.montserrat(fontSize: 20.0),
        ),
      ),
    );
  }
}

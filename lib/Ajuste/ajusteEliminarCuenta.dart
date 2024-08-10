import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_color/flutter_color.dart';

class ajusteEliminarCuenta extends StatelessWidget {
  const ajusteEliminarCuenta({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#FFFFFF'),
        iconTheme: IconThemeData(
          color: HexColor('#929292'), // Color de los íconos del AppBar
        ),
        title: Text(
          'Ajustes',
          style: GoogleFonts.montserrat(
            color: HexColor('#929292'),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: HexColor('#FFFFFF'), // Color de fondo de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 10.0),
              child: Text(
                'Eliminar mi cuenta',
                style: GoogleFonts.montserrat(
                  color: HexColor('#FC4343'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 10.0),
                child: Text(
                  'Si eliminas tu cuenta se borrarán todos tus datos dentro de la aplicación de manera definitiva, (está solicitud puede tomar hasta 15 días hábiles).\n\n¿Estás seguro de borrar tu cuenta?',
                  style: GoogleFonts.montserrat(
                    color: HexColor('#FF0000'),
                  ),
                  textAlign: TextAlign.start,
                ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 130.0), // Reducir el espacio vertical
              child: ElevatedButton(
                onPressed: () {
                  // Acción a realizar cuando se presione el botón
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FC4343'),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Reducir el padding del botón
                ),
                child: Text(
                  'Eliminar cuenta',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0, // Reducir el tamaño del texto
                    color: HexColor('#ffffff'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
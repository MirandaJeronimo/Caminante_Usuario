import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_color/flutter_color.dart';

class AjustesSolicitarInformacion extends StatelessWidget {
  const AjustesSolicitarInformacion({super.key});

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
                'Info. de mi cuenta',
                style: GoogleFonts.montserrat(
                  color: HexColor('#FF0080'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
              child: Center(
                child: Text(
                  'Crea un informe de los ajustes de configuración y la información de tu cuenta de caminante. Puedes acceder y transferir la información a otra aplicación. El informe no incluye tus mensajes.',
                  style: GoogleFonts.montserrat(
                    color: HexColor('#929292'),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 8.0), // Reducir el espacio vertical
              child: ElevatedButton(
                onPressed: () {
                  // Acción a realizar cuando se presione el botón
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FF0080'),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Reducir el padding del botón
                ),
                child: Text(
                  'Solicitar informe',
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

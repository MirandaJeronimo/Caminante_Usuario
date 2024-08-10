import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:google_fonts/google_fonts.dart';

class ajusteContactanos extends StatelessWidget {
  const ajusteContactanos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: HexColor('#929292'), // Color hex #929292
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Ajustes',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: HexColor('808080')),
              fontWeight: FontWeight.bold,// Gris
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Contactanos',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: HexColor('#FF0080'),
                    fontWeight: FontWeight.w600, // Semibold
                    fontSize: 24, // Tamaño de fuente
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre el título y el TextField
              TextField(
                maxLines: 4, // Número máximo de líneas que se mostrarán
                decoration: InputDecoration(
                  hintText: 'Describe el problema',
                  hintStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: HexColor('#929292'), // Color hex #929292
                      fontSize: 16, // Tamaño de fuente
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: HexColor('#929292'), // Color hex #929292
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Espacio entre el TextField y el texto "Añade capturas de pantalla (opcional)"
              Text(
                'Añade capturas de pantalla (opcional)',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: HexColor('#929292'), // Color hex #929292
                    fontWeight: FontWeight.w500, // Medium
                    fontSize: 14, // Tamaño de fuente
                  ),
                ),
              ),
              SizedBox(height: 10), // Espacio entre el texto y los botones
              // Fila de botones centrada
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra los botones horizontalmente
                  children: <Widget>[
                    Container(
                      width: 72, // Ancho del contenedor del botón
                      height: 72, // Altura del contenedor del botón
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), // Bordes redondeados
                        color: HexColor('#D1D1D1'), // Color hex #D1D1D1
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 32), // Icono de cámara
                        onPressed: () {
                          // Acción cuando se presiona el botón
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Espacio entre el primer y segundo botón
                    Container(
                      width: 72, // Ancho del contenedor del botón
                      height: 72, // Altura del contenedor del botón
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), // Bordes redondeados
                        color: HexColor('#D1D1D1'), // Color hex #D1D1D1
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 32), // Icono de cámara
                        onPressed: () {
                          // Acción cuando se presiona el botón
                        },
                      ),
                    ),
                    SizedBox(width: 16), // Espacio entre el segundo y tercer botón
                    Container(
                      width: 72, // Ancho del contenedor del botón
                      height: 72, // Altura del contenedor del botón
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), // Bordes redondeados
                        color: HexColor('#D1D1D1'), // Color hex #D1D1D1
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, size: 32), // Icono de cámara
                        onPressed: () {
                          // Acción cuando se presiona el botón
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50), // Espacio entre los botones y el ElevatedButton
              // ElevatedButton
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0), // Ajustar padding horizontal
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción cuando se presiona el botón
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0), // Borde más redondeado
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 56.0), // Padding ajustado
                      backgroundColor: HexColor('#FF0080'), // Color hex #FF0080
                    ),
                    child: Text(
                      'Continuar',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white, // Color del texto blanco
                          fontSize: 18, // Tamaño de fuente
                          fontWeight: FontWeight.w600, // Semibold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

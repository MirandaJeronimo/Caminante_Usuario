import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_color/flutter_color.dart';

class rating_dialog extends StatelessWidget {
  const rating_dialog({super.key});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '¿Cómo calificas nuestra aplicación?',
        style: GoogleFonts.montserrat(
          color: HexColor('#535151'),
          fontSize: 18.0,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            itemSize: 30,
            allowHalfRating: true,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: HexColor('#FF0080'),
            ),
            onRatingUpdate: (rating) {
              // Aquí puedes almacenar la calificación si es necesario
            },
          ),
          SizedBox(height: 20.0), // Espacio entre el RatingBar y los botones
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones al final
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text(
                'Cancelar',
                style: GoogleFonts.montserrat(
                  color: HexColor('#FF0080'),
                  fontSize: 14.0,
                ),
              ),
            ),
            SizedBox(width: 10.0), // Espacio reducido entre los botones
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar el envío de la calificación
                Navigator.of(context).pop(); // Cierra el diálogo después de enviar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#FF0080'), // Color del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Ajusta el padding para el tamaño
                minimumSize: Size(90, 40), // Ajusta el tamaño mínimo del botón
              ),
              child: Text(
                'Enviar',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14.0, // Ajusta el tamaño del texto si es necesario
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

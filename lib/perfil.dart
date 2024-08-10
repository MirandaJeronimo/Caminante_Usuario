import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart'; // Asegúrate de que este paquete esté incluido en tu pubspec.yaml
import 'package:google_fonts/google_fonts.dart'; // Importa la librería de Google Fonts
import 'package:caminante_appvsc/eventos.dart';
import 'package:caminante_appvsc/favoritos.dart';
import 'package:caminante_appvsc/ajustes.dart';
import 'package:caminante_appvsc/sites.dart';
import 'Perfil/perfil_cuponesScreen.dart'; // Importa la nueva pantalla
import 'Perfil/perfil_visitas.dart'; // Importa la nueva pantalla
import 'Perfil/perfil_logrosScreen.dart'; // Importa la nueva pantalla
import 'Perfil/perfil_linea_emergenciaScreen.dart'; // Importa la nueva pantalla
import  'package:caminante_appvsc/rating_dialog.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Añadimos el top bar con el degradado lineal vertical
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180.0), // Altura personalizada para la AppBar
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HexColor('#FF0080'), // Primer color del degradado
                  HexColor('#8F3A7C'), // Segundo color del degradado
                ],
                begin: Alignment.topCenter, // Comienza en la parte superior
                end: Alignment.bottomCenter, // Termina en la parte inferior
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // CircleAvatar para mostrar la imagen de perfil
                  CircleAvatar(
                    radius: 50.0, // Tamaño del CircleAvatar
                    backgroundImage: AssetImage('assets/fondo.png'), // Imagen del perfil
                    backgroundColor: Colors.transparent,
                  ),

                  // Espaciador entre el CircleAvatar y el texto
                  SizedBox(width: 16.0),

                  // Columna para el texto de nombre y subtítulo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Texto del nombre en negritas y blanco usando Google Fonts
                      Text(
                        'Nombre del perfil',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      // Espaciado entre el nombre y el subtítulo
                      SizedBox(height: 0.0),
                      // Subtítulo usando Google Fonts
                      Text(
                        'tipoEstablecimiento',
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),

                  // Espaciador vacío a la derecha para llenar el espacio
                  Spacer(),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent, // Hacer el fondo de AppBar transparente
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espaciador superior para el título
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 36.0, right: 16.0),
            child: Text(
              'Perfil',
              style: GoogleFonts.montserrat(
                color: HexColor('#FF0080'),
                fontWeight: FontWeight.bold,
                fontSize: 20.0, // Tamaño del texto ajustado a 22
              ),
            ),
          ),
          // Menú de opciones debajo del título
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.card_giftcard, 'Mis cupones', context, perfil_cuponesScreen()),
                _buildMenuItem(Icons.history, 'Mis visitas', context, perfil_visitasScreen()),
                _buildMenuItem(Icons.emoji_events, 'Logros obtenidos', context, perfil_logrosScreen()),
                _buildMenuItem(Icons.local_hospital, 'Líneas de emergencia', context, perfil_linea_emergenciaScreen()),
                _buildMenuItem(Icons.help_outline, 'Ayúdanos', context, null, hasDivider: false), // Última opción sin separador
                SizedBox(height: 20.0), // Espaciador antes del botón
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: HexColor('#FF0080'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Grosor del botón
                      ),
                    ),
                    onPressed: () {
                      // Acción del botón
                    },
                    child: Text(
                      'Tarifas de precios en playa',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0), // Espaciador después del botón
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          color: HexColor('#FFFFFF'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(context, 'assets/perfil.png', const PerfilScreen(), isSelected: true),
              _buildIconButton(context, 'assets/calendario.png', const EventosScreen(), isSelected: false),
              _buildIconButton(context, 'assets/home.png', const SitesScreen(), isSelected: false),
              _buildIconButton(context, 'assets/favoritos.png', const FavoritosScreen(), isSelected: false),
              _buildIconButton(context, 'assets/ajustes.png', const AjustesScreen(), isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context, Widget? screen, {bool hasDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 36.0, right: 16.0), // Padding izquierdo para el contenido del ListTile
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0), // Añade padding vertical para mayor separación
            child: ListTile(
              contentPadding: EdgeInsets.zero, // Elimina el padding interno predeterminado de ListTile
              leading: Icon(icon, color: HexColor('#FF0080')), // Color del icono
              title: Text(
                title,
                style: GoogleFonts.montserrat(
                  color: HexColor('#535151'), // Color del texto
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                if (title == 'Ayúdanos') {
                  showDialog(
                    context: context,
                    builder: (context) => const rating_dialog(),
                  );
                } else if (screen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                }
              },
            ),
          ),
        ),
        if (hasDivider)
          Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 16.0), // Mueve el separador hacia la derecha
            child: Divider(
              color: HexColor('#8F3A7C'),
              thickness: 2.0, // Grosor del separador
              indent: 36.0, // Indentación para hacer el separador más corto
              endIndent: 0.0, // Espacio al final del separador
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, String imagePath, Widget screen, {required bool isSelected}) {
    return SizedBox(
      width: 60.0,
      child: IconButton(
        onPressed: () {
          if (isSelected) {
            return; // Evita la navegación si la pantalla ya está seleccionada.
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        icon: Image.asset(
          imagePath,
          width: 35.0,
          color: isSelected ? Colors.blue : null, // Ajusta el color si está seleccionado.
        ),
      ),
    );
  }
}

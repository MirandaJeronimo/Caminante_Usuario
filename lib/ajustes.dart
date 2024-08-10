import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caminante_appvsc/perfil.dart';
import 'package:caminante_appvsc/eventos.dart';
import 'package:caminante_appvsc/favoritos.dart';
import 'package:caminante_appvsc/sites.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//perfil
import 'package:caminante_appvsc/Ajuste/ajusteInformacionPersonalScreen.dart';
import 'package:caminante_appvsc/Ajuste/ajusteFotoPerfilScreen.dart';
//general
import 'package:caminante_appvsc/Ajuste/ajusteSolicitarInformacion.dart';
import 'package:caminante_appvsc/Ajuste/ajusteEliminarCuenta.dart';
//almacenamiento
import 'package:caminante_appvsc/Ajuste/ajusteAdministrarAlmacenamiento.dart';
//ayuda
import 'package:caminante_appvsc/Ajuste/ajusteCentroAyuda.dart';
import 'package:caminante_appvsc/Ajuste/ajusteInfoApp.dart';
import 'package:caminante_appvsc/Ajuste/ajusteContactanos.dart';
import 'package:caminante_appvsc/Ajuste/ajustePoliticasCondiciones.dart';
import 'package:caminante_appvsc/Ajuste/ajusteSuperIC.dart';
import 'package:caminante_appvsc/Ajuste/ajusteReglasConsumidor.dart';
import 'package:caminante_appvsc/Ajuste/ajusteNormasConvivenciaCiudadana.dart';




final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _notificaciones = true;
  bool _localizacion = true;

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _toggleNotifications(bool isEnabled) {
    setState(() {
      _notificaciones = isEnabled;
    });

    if (isEnabled) {
      // Código para activar las notificaciones
    } else {
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  void _toggleLocation(bool isEnabled) async {
    setState(() {
      _localizacion = isEnabled;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#FFFFFF'),
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: GoogleFonts.montserrat(
            color: HexColor('#707070'),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: HexColor('#707070'), // Color del icono de regresar
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          color: HexColor('#FFFFFF'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(
                context,
                'assets/perfil.png',
                const PerfilScreen(),
                isSelected: false,
              ),
              _buildIconButton(
                context,
                'assets/calendario.png',
                const EventosScreen(),
                isSelected: false,
              ),
              _buildIconButton(
                context,
                'assets/home.png',
                const SitesScreen(),
                isSelected: false,
              ),
              _buildIconButton(
                context,
                'assets/favoritos.png',
                const FavoritosScreen(),
                isSelected: false,
              ),
              _buildIconButton(
                context,
                'assets/ajustes.png',
                const AjustesScreen(),
                isSelected: true,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection(context, 'Perfil', ['Foto de Perfil', 'Información Personal']),
            _buildSection(context, 'General', ['Notificaciones', 'Localización', 'Solicitar información', 'Eliminar cuenta']),
            _buildSection(context, 'Almacenamiento', ['Administrar Almacenamiento']),
            _buildSection(context, 'Ayuda', ['Centro de ayuda', 'Información sobre la App', 'Contáctanos', 'Políticas y condiciones', 'Superintendencia y comercio', 'Reglas del consumidor', 'Normas de convivencia ciudadana']),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FF0080'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onPressed: () {
                  // Agregar lógica para cerrar sesión
                  // Por ejemplo:
                  // Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Cerrar sesión',
                  style: GoogleFonts.montserrat(
                    color: HexColor('#ffffff'),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0), // Ajuste de espaciado
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: HexColor('#FF0080'),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: options.map((option) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0), // Ajuste de espaciado
                      dense: true, // Reduce el espacio entre los elementos del ListTile
                      title: Text(
                        option,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                        ),
                      ),
                      trailing: (option == 'Notificaciones' || option == 'Localización')
                          ? Switch(
                        value: option == 'Notificaciones' ? _notificaciones : _localizacion,
                        onChanged: (value) {
                          if (option == 'Notificaciones') {
                            _toggleNotifications(value);
                          } else if (option == 'Localización') {
                            _toggleLocation(value);
                          }
                        },
                      )
                          : null,
                      onTap: () {
                        // Navegación a las pantallas correspondientes
                        switch (option) {
                          case 'Foto de Perfil':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteFotoPerfilScreen()));
                            break;
                          case 'Información Personal':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteInformacionPersonalScreen()));
                            break;
                          case 'Solicitar información':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AjustesSolicitarInformacion()));
                            break;
                          case 'Eliminar cuenta':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteEliminarCuenta()));
                            break;
                          case 'Administrar Almacenamiento':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteAdministrarAlmacenamiento()));
                            break;
                          case 'Centro de ayuda':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteCentroAyuda()));
                            break;
                          case 'Información sobre la App':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteInfoApp()));
                            break;
                          case 'Contáctanos':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteContactanos()));
                            break;
                          case 'Políticas y condiciones':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajustePoliticasCondiciones()));
                            break;
                          case 'Superintendencia y comercio':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteSuperIC()));
                            break;
                          case 'Reglas del consumidor':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteReglasConsumidor()));
                            break;
                          case 'Normas de convivencia ciudadana':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajusteNormasConvivenciaCiudadana()));
                            break;
                          default:
                          // Handle other options if needed
                        // Agrega casos adicionales aquí si es necesario
                        }
                      },
                    ),
                    if (option != options.last) // Añade Divider entre elementos, excepto el último
                      Container(
                        width: 280, // Ancho de la línea de separación
                        height: 1,
                        color: HexColor('#c2c2c2'),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, String imagePath, Widget screen,
      {required bool isSelected}) {
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

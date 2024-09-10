import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firebase Firestore
import 'package:caminante_appvsc/perfil.dart';
import 'package:caminante_appvsc/eventos.dart';
import 'package:caminante_appvsc/favoritos.dart';
import 'package:caminante_appvsc/ajustes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'search_screen.dart'; // Importa la nueva pantalla de búsqueda
import 'package:qrscan/qrscan.dart' as scanner;  // Importa lectorqr
import 'package:permission_handler/permission_handler.dart'; // Importa permisosparacamara
import 'package:url_launcher/url_launcher.dart'; // Importa url_launcher
import 'chatbot_screen.dart'; // Importa la pantalla del chatbot



class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  _SitesScreenState createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  late GoogleMapController _mapController;
  late TextEditingController _searchController;
  bool _showPanel = false;
  List entidades = [];  // Lista para las entidades de Firebase
  Map<String, dynamic>? entidadSeleccionada;  // Entidad seleccionada al presionar el marcador
  Set<Marker> _markers = {};  // Conjunto de marcadores para el mapa

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      for (var entidad in entidades) {
        print('Agregando marcador para: ${entidad['nombreEntidad']}'); // Agregar impresión
        _markers.add(
          Marker(
            markerId: MarkerId(entidad['nombreEntidad']),
            position: LatLng(entidad['latitud'], entidad['longitud']),
            infoWindow: InfoWindow(
              title: entidad['nombreEntidad'],
              snippet: entidad['categoria'],
            ),
              onTap: () {
                setState(() {
                  entidadSeleccionada = entidad; // Asignar entidad seleccionada
                });

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Permitir que el BottomSheet ocupe más espacio
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.9, // Ocupar el 90% de la pantalla
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagen de la entidad o fondo predeterminado
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  'assets/fondo.png', // Imagen predeterminada
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // Información de la entidad
                              Text(
                                entidadSeleccionada!['nombreEntidad'] ?? 'Nombre no disponible',
                                style: GoogleFonts.montserrat(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                entidadSeleccionada!['categoria'] ?? 'Categoría no disponible',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Divider(),

                              // Página Oficial
                              Text(
                                'Página Oficial',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                entidadSeleccionada!['paginaOficial'] ?? 'No disponible',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  color: Colors.blue, // Enlace en azul
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Divider(),

                              // Correo de la Empresa
                              Text(
                                'Correo de la Empresa',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                entidadSeleccionada!['correoInstitucional'] ?? 'No disponible',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Divider(),

                              // Horarios de atención (si están disponibles)
                              Text(
                                'Horario de atención',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Lunes a Viernes: 8:00 AM - 8:00 PM', // Ejemplo de horario
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Divider(),

                              // Descripción
                              Text(
                                'Descripción',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                entidadSeleccionada!['naturalezaEntidad'] ?? 'Descripción no disponible',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );


              }

          ),
        );
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadEntidades(); // Cargar las entidades desde Firebase al iniciar
  }

  // Función para cargar las entidades desde Firebase
  void _loadEntidades() async {
    FirebaseFirestore.instance.collection('entidades').get().then((snapshot) {
      setState(() {
        for (var doc in snapshot.docs) {
          Map<String, dynamic> entidad = doc.data();

          // Extraer coordenadas del campo 'ubicacion'
          String ubicacion = entidad['ubicacion'];
          List<String> partesUbicacion = ubicacion.split("Coordenadas:");
          if (partesUbicacion.length == 2) {
            // Extraer latitud y longitud
            List<String> coordenadas = partesUbicacion[1].trim().split(",");
            double latitud = double.parse(coordenadas[0]);
            double longitud = double.parse(coordenadas[1]);

            // Añadir las coordenadas extraídas al mapa
            entidad['latitud'] = latitud;
            entidad['longitud'] = longitud;

            // Agregar la entidad con coordenadas a la lista
            entidades.add(entidad);
          }
        }
        // Una vez que se cargan las entidades, actualiza los marcadores en el mapa
        _onMapCreated(_mapController);
      });
    });
  }

  Future<void> requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }

    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> scanQRCode() async {
    await requestPermissions(); // Solicitar permisos si aún no se han otorgado
    try {
      String? scanResult = await scanner.scan();
      if (scanResult != null) {
        // Intenta lanzar la URL si es válida
        if (await canLaunch(scanResult)) {
          await launch(scanResult);
        } else {
          // Si no se puede lanzar, muestra un mensaje de error
          print('No se puede abrir la URL: $scanResult');
        }
      } else {
        print('No se obtuvo ningún resultado del escaneo.');
      }
    } catch (e) {
      print('Error al escanear el código QR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.3910, -75.4794),
              zoom: 15.0,
            ),
            markers: _markers, // Mostrar los marcadores en el mapa
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: HexColor('#FFFFFF'),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar en el mapa',
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  enabled: false, // Deshabilitar el TextField para que no se pueda editar directamente
                ),
              ),
            ),
          ),
          SlidingUpPanel(
            minHeight: 10,
            maxHeight: 700,
            body: Container(),
            panel: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    'Transportes y rutas',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: HexColor('#929292'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            side: BorderSide(color: HexColor('#FF0080')),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8.0),
                              Text(
                                'Departamental',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#FF0080'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            side: BorderSide(color: HexColor('#FF0080')),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8.0),
                              Text(
                                'Local',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#FF0080'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Categorías',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: HexColor('#929292'),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 13,
                      separatorBuilder: (context, index) => Column(
                        children: [
                          const SizedBox(height: 8.0),
                          Divider(color: HexColor('#FF0080')),
                        ],
                      ),
                      itemBuilder: (context, index) {
                        String category;
                        IconData iconData;
                        switch (index) {
                          case 0:
                            category = 'Comida';
                            iconData = Icons.fastfood_outlined;
                            break;
                          case 1:
                            category = 'Hospedaje';
                            iconData = Icons.hotel_outlined;
                            break;
                          case 2:
                            category = 'Rumba';
                            iconData = Icons.music_note_outlined;
                            break;
                          case 3:
                            category = 'Parranda';
                            iconData = Icons.celebration_outlined;
                            break;
                          case 4:
                            category = 'Pasar el rato';
                            iconData = Icons.event_outlined;
                            break;
                          case 5:
                            category = 'Compras';
                            iconData = Icons.shopping_bag_outlined;
                            break;
                          case 6:
                            category = 'Servicios turísticos';
                            iconData = Icons.location_city_outlined;
                            break;
                          case 7:
                            category = 'Zonas turísticas';
                            iconData = Icons.landscape_outlined;
                            break;
                          case 8:
                            category = 'Establecimientos públicos';
                            iconData = Icons.store_outlined;
                            break;
                          case 9:
                            category = 'Estación de transporte';
                            iconData = Icons.train_outlined;
                            break;
                          case 10:
                            category = 'Talleres';
                            iconData = Icons.build_outlined;
                            break;
                          case 11:
                            category = 'Cuidado personal';
                            iconData = Icons.spa_outlined;
                            break;
                          case 12:
                            category = 'Emergencia';
                            iconData = Icons.local_hospital_outlined;
                            break;
                          default:
                            category = 'Otra categoría';
                            iconData = Icons.category_outlined;
                        }
                        return TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(iconData, color: HexColor('#FF0080'), size: 24.0),
                              const SizedBox(width: 16.0),
                              Text(
                                category,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: HexColor('#FF0080'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            onPanelSlide: (double pos) {
              setState(() {
                _showPanel = true;
              });
            },
            onPanelClosed: () {
              setState(() {
                _showPanel = false;
              });
            },
          ),
          Positioned(
            right: 16.0,
            top: MediaQuery.of(context).size.height / 2 - 28.0, // Ajusta la posición vertical para estar en la mitad
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    await scanQRCode();
                  },
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                  ),
                  backgroundColor: HexColor('#FF0080'),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatBotScreen()),
                    );
                  },
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  backgroundColor: HexColor('#FF0080'), // Cambia el color si lo prefieres
                ),
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
              _buildIconButton(context, 'assets/perfil.png', const PerfilScreen(), isSelected: false),
              _buildIconButton(context, 'assets/calendario.png', const EventosScreen(), isSelected: false),
              _buildIconButton(context, 'assets/home.png', const SitesScreen(), isSelected: true),
              _buildIconButton(context, 'assets/favoritos.png', const FavoritosScreen(), isSelected: false),
              _buildIconButton(context, 'assets/ajustes.png', const AjustesScreen(), isSelected: false),
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

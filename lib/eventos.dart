import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:caminante_appvsc/perfil.dart';
import 'package:caminante_appvsc/favoritos.dart';
import 'package:caminante_appvsc/ajustes.dart';
import 'package:caminante_appvsc/sites.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firebase Firestore

class Event {
  final String title;
  final String description;
  final String location;
  final DateTime fechaInicio;

  Event({
    required this.title,
    required this.description,
    required this.location,
    required this.fechaInicio,
  });
}

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Event> _events = []; // Lista de todos los eventos cargados

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // Función para cargar eventos desde Firebase
  void _loadEvents() async {
    FirebaseFirestore.instance.collection('eventos').get().then((snapshot) {
      List<Event> events = snapshot.docs.map((doc) {
        var data = doc.data();
        DateTime fechaInicio = (data['fechaInicio'] as Timestamp).toDate();
        return Event(
          title: data['nombre'] ?? 'Sin título',
          description: data['descripcion'] ?? 'Sin descripción',
          location: data['ubicacion'] ?? 'Sin ubicación',
          fechaInicio: fechaInicio,
        );
      }).toList();

      setState(() {
        _events = events; // Asigna todos los eventos a la lista
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#8F3A7C'),
        title: _buildCustomHeader(_focusedDay),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SlidingUpPanel(
        panelBuilder: (scrollController) => _buildEventList(scrollController),
        color: HexColor('#8F3A7C'),
        body: Container(
          color: HexColor('#8F3A7C'),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: _buildCalendar(),
              ),
            ],
          ),
        ),
        minHeight: 350.0,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        clipBehavior: Clip.none,
        child: Container(
          height: 60.0,
          color: HexColor('#FFFFFF'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(context, 'assets/perfil.png', const PerfilScreen(), isSelected: false),
              _buildIconButton(context, 'assets/calendario.png', const EventosScreen(), isSelected: true),
              _buildIconButton(context, 'assets/home.png', const SitesScreen(), isSelected: false),
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
            return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        icon: Image.asset(
          imagePath,
          width: 35.0,
          color: isSelected ? Colors.blue : null,
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      headerVisible: false,
      selectedDayPredicate: (day) {
        return isSameDay(day, _selectedDay);
      },
    );
  }

  Widget _buildCustomHeader(DateTime focusedDay) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 85.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.utc(
                  _focusedDay.year,
                  _focusedDay.month - 1,
                  _focusedDay.day,
                );
              });
            },
          ),
          Text(
            DateFormat.MMMM().format(focusedDay),
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.utc(
                  _focusedDay.year,
                  _focusedDay.month + 1,
                  _focusedDay.day,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  // Mostrar todos los eventos en el SlidingUpPanel
  Widget _buildEventList(ScrollController scrollController) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: _events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(_events[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                event.title,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: HexColor('#FF0080'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                event.description,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: HexColor('#808080')),
                ),
              ),
            ),
            const SizedBox(height: 1.0),
            if (event.location.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ubicación: ${event.location}',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: HexColor('#808080')),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Fecha de inicio: ${DateFormat('dd MMM yyyy').format(event.fechaInicio)}',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: HexColor('#808080')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

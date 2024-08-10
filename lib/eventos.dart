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

class Event {
  final String title;
  final String description;
  final String imagePath; // Nueva propiedad para la ruta de la imagen

  Event({required this.title, required this.description, required this.imagePath});
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
  final Map<DateTime, List<Event>> _events = {};
  bool _showToday = true;
  bool _showAgenda = false;

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
        color: HexColor('#8F3A7C'), // Color de fondo del panel
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
        minHeight: 400.0, // Altura mínima del panel
        maxHeight: MediaQuery.of(context).size.height * 0.8, // Altura máxima del panel
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          color: HexColor('#FFFFFF'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(context, 'assets/perfil.png', const PerfilScreen(),isSelected: false,),
              _buildIconButton(context, 'assets/calendario.png', const EventosScreen(),isSelected: true,),
              _buildIconButton(context, 'assets/home.png', const SitesScreen(),isSelected: false,),
              _buildIconButton(context, 'assets/favoritos.png', const FavoritosScreen(),isSelected: false,),
              _buildIconButton(context, 'assets/ajustes.png', const AjustesScreen(),isSelected: false,),
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
        _showAddEventDialog(context);
      },
      eventLoader: _getEventsForDay,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: HexColor('#FF0080'),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: HexColor('#FF0080'),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: HexColor('#FF0080')),
        holidayTextStyle: TextStyle(color: HexColor('#FF0080')),
      ),
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
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
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

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildEventList(ScrollController scrollController) {
    List<Event> events = _events[_showToday ? _selectedDay : DateTime.now()] ?? [];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showToday = true;
                    _showAgenda = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'Hoy',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: _showToday ? Colors.white : Colors.white54,
                        fontSize: 20.0,
                        fontWeight: _showToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                ' | ',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showToday = false;
                    _showAgenda = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Tu Agenda',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: _showAgenda ? Colors.white : Colors.white54,
                        fontSize: 20.0,
                        fontWeight: _showAgenda ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(events[index]);
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
        child: Stack(
          children: [
            Column(
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
                const SizedBox(height: 1.0), // Espacio entre el texto y la imagen
                if (event.imagePath.isNotEmpty)
                  Center(
                    child: Container(
                      width: 330.0, // Ajusta el ancho del contenedor según tus preferencias
                      height: 250.0, // Ajusta el alto del contenedor según tus preferencias
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        // Alinea la imagen al centro del contenedor y la hace un poco más grande
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(event.imagePath),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/Compartir.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {
                      // Acción al presionar el botón de compartir
                      // Puedes implementar aquí la lógica para compartir el evento
                      // Puedes usar la función share del paquete share
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/Guardar.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    onPressed: () {
                      // Acción al presionar el botón de guardar
                      // Puedes implementar aquí la lógica para guardar el evento
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent(DateTime day, String title, String description) {
    setState(() {
      _events[day] = (_events[day] ?? [])
        ..add(Event(
          title: title,
          description: description,
          imagePath: 'assets/fondo.png', // Ruta de la imagen predeterminada
        ));
    });
  }

  void _showAddEventDialog(BuildContext context) {
    String title = '';
    String description = '';
    DateTime selectedDate = _selectedDay;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Evento'),
          content: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      ),
                    ),
                    child: const Text('Seleccionar fecha'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _addEvent(
                  selectedDate,
                  title.isNotEmpty ? title : 'Nuevo Evento',
                  description.isNotEmpty
                      ? description
                      : 'Descripción del evento',
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
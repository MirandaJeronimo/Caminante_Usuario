import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:caminante_appvsc/services/firebase_service.dart';
import 'package:caminante_appvsc/perfil.dart';
import 'package:caminante_appvsc/eventos.dart';
import 'package:caminante_appvsc/ajustes.dart';
import 'package:caminante_appvsc/sites.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<Map<String, dynamic>> people = [];

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  void fetchPeople() async {
    try {
      List<Map<String, dynamic>> fetchedPeople = (await getPeople()).cast<Map<String, dynamic>>();
      setState(() {
        people = fetchedPeople;
      });
    } catch (e) {
      print("Error al obtener los datos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: HexColor('#8F3A7C'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdownButton('Municipio'),
                _buildDropdownButton('Categoría'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recomendados',
              style: TextStyle(
                color: HexColor('#8F3A7C'),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          people.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: people.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Mostrar dos elementos por fila
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7, // Ajustar la relación de aspecto de los elementos
                ),
                itemBuilder: (context, index) {
                  return _buildGridItem(people[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Destacados',
              style: TextStyle(
                color: HexColor('#8F3A7C'),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: people.length, // Puedes cambiar este valor según tus destacados
              itemBuilder: (context, index) {
                return _buildHorizontalListItem(people[index]);
              },
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
              _buildIconButton(context, 'assets/home.png', const SitesScreen(), isSelected: false),
              _buildIconButton(context, 'assets/favoritos.png', const FavoritosScreen(), isSelected: true),
              _buildIconButton(context, 'assets/ajustes.png', const AjustesScreen(), isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String text) {
    return DropdownButton<String>(
      value: text,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      onChanged: (String? newValue) {
        // Actualiza la selección
      },
      items: <String>[text].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> person) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: person['imageUrl'] != null
              ? NetworkImage(person['imageUrl'])
              : const AssetImage('assets/placeholder.png') as ImageProvider, // Usa una imagen por defecto si es nulo
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            person['nombre'] ?? 'Sin nombre', // Muestra "Sin nombre" si el campo está vacío o nulo
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalListItem(Map<String, dynamic> person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: person['imageUrl'] != null
              ? NetworkImage(person['imageUrl'])
              : const AssetImage('assets/placeholder.png') as ImageProvider, // Usa una imagen por defecto si es nulo
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            person['nombre'] ?? 'Sin nombre', // Muestra "Sin nombre" si el campo está vacío o nulo
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHorizontalGridItem(Map<String, dynamic> person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: person['imageUrl'] != null
              ? NetworkImage(person['imageUrl'])
              : const AssetImage('assets/fondo.png') as ImageProvider, // Usa 'fondo.png' si no hay URL de imagen
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            person['nombre'] ?? 'Sin nombre', // Muestra "Sin nombre" si el campo está vacío o nulo
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
}

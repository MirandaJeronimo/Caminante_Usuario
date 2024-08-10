import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_color/flutter_color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = []; // Lista para almacenar resultados de búsqueda
  final List<String> _suggestedItems = ['Lugar sugerido 1', 'Lugar sugerido 2', 'Lugar sugerido 3'];
  final List<String> _recentItems = ['Búsqueda reciente 1', 'Búsqueda reciente 2', 'Búsqueda reciente 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#8F3A7C'), // Cambia el color de fondo del Scaffold
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Busca aquí a donde quieres ir',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 16.0,
              color: HexColor('#ffffff'),
            ), // Estilo de fuente para el hintText
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Lógica de búsqueda aquí
            setState(() {
              _searchResults = _performSearch(value);
            });
          },
          style: GoogleFonts.montserrat(
            fontSize: 16.0,
            color: HexColor('#ffffff'),
          ), // Estilo de fuente para el texto ingresado
        ),
        backgroundColor: HexColor('#9B7392'), // Color de fondo del AppBar
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20.0, // Tamaño de fuente del título
          fontWeight: FontWeight.bold, // Peso de fuente del título
          color: Colors.white, // Color de fuente del título
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color del ícono del botón de regresar
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Sugeridos', HexColor('#FFFFFF')),
          _buildSuggestedItems(),
          const SizedBox(height: 20.0),
          _buildSectionTitle('Recientes', HexColor('#FFFFFF')),
          _buildRecentItems(),
          const SizedBox(height: 20.0),
          _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18.0,
          fontWeight: FontWeight.w600, // Cambiado a SemiBold (w600)
          color: color,
        ),
      ),
    );
  }

  Widget _buildSuggestedItems() {
    return Column(
      children: _suggestedItems.map((item) {
        return ListTile(
          leading: Icon(Icons.star_outline, color: HexColor('#FFFFFF')), // Icono de favoritos
          title: Text(
            item,
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: HexColor('#FFFFFF'), // Color blanco para el texto
            ),
          ),
          onTap: () {
            // Implementa la acción cuando se selecciona un elemento sugerido
            _handleResultTap(item);
          },
        );
      }).toList(),
    );
  }

  Widget _buildRecentItems() {
    return Column(
      children: _recentItems.map((item) {
        return ListTile(
          leading: Icon(Icons.access_time, color: HexColor('#FFFFFF')), // Icono de reciente
          title: Text(
            item,
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: HexColor('#FFFFFF'), // Color blanco para el texto
            ),
          ),
          onTap: () {
            // Implementa la acción cuando se selecciona un elemento reciente
            _handleResultTap(item);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _searchResults[index],
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
                color: HexColor('#FF0080'),
              ),
            ),
            onTap: () {
              // Acción al seleccionar un resultado de búsqueda
              _handleResultTap(_searchResults[index]);
            },
          );
        },
      ),
    );
  }

  // Función para realizar la búsqueda simulada
  List<String> _performSearch(String query) {
    // Simulación de resultados de búsqueda
    List<String> results = [];
    if (query.isNotEmpty) {
      for (int i = 1; i <= 10; i++) {
        results.add('Resultado de búsqueda $i para "$query"');
      }
    }
    return results;
  }

  // Función para manejar la acción al seleccionar un resultado de búsqueda
  void _handleResultTap(String result) {
    // Implementa la acción según el resultado seleccionado
    print('Resultado seleccionado: $result');
    // Ejemplo: Navegar a una pantalla de detalles o realizar otra acción relevante
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

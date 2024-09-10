import 'package:flutter/material.dart';
import 'dart:convert'; // Para manejar JSON
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = ''; // Almacena la respuesta de la IA

  // API Key de OpenAI (agrega tu clave aquí)
  String apiKey = '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';

  // Función para enviar un mensaje al chatbot
  Future<void> _sendMessage(String message) async {
    // Agrega un retraso de 2 segundos entre solicitudes
    await Future.delayed(Duration(seconds: 2));

    var url = Uri.https("api.openai.com", "/v1/chat/completions");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": message}
      ]
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _response = data['choices'][0]['message']['content'];
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response), // Muestra la respuesta del chatbot
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Escribe un mensaje',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                String message = _controller.text;
                _sendMessage(message);
                _controller.clear();
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

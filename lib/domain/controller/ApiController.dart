// ignore_for_file: file_names, unused_import

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ApiController {
  final String baseUrl;
  final String apiKey;
  final http.Client _client = http.Client();

  ApiController({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> obtenerDatosFinancieros({
    required String function,
    required String symbol,
    String outputSize = 'compact',
    String dataType = 'json',
  }) async {
    String apiUrl =
        '$baseUrl?function=$function&symbol=$symbol&outputsize=$outputSize&datatype=$dataType&apikey=$apiKey';

    try {
      final response = await _client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Fallo al obtener los datos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  double generarDatoAleatorio() {
    // Generar datos aleatorios para simular variación
    return Random().nextDouble() * 10.0;
  }
}

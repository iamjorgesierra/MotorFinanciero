// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  final String baseUrl;
  final String apiKey;

  ApiController({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> obtenerDatosFinancieros({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/query?function=CURRENCY_EXCHANGE_RATE'
          '&from_currency=$fromCurrency&to_currency=$toCurrency&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener datos financieros');
    }
  }
}

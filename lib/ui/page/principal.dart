import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:motor_financiero/domain/controller/ApiController.dart';

class MiPantalla extends StatefulWidget {
  const MiPantalla({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MiPantallaState createState() => _MiPantallaState();
}

class _MiPantallaState extends State<MiPantalla> {
  final ApiController _apiController = ApiController(
    baseUrl: 'https://www.alphavantage.co',
    apiKey: 'HKJUDS1MVJYXNVBG',
  );

  // Definir las monedas de origen y destino
  final String fromCurrency = 'USD';
  final String toCurrency = 'JPY';

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Aplicación Financiera'),
      ),
      body: FutureBuilder(
        future: _apiController.obtenerDatosFinancieros(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Obtén los datos necesarios para construir el gráfico.
            String exchangeRateString =
                snapshot.data?['Realtime Currency Exchange Rate']
                        ['5. Exchange Rate'] ??
                    '0.0';

            // Convierte la cadena a un valor double
            double exchangeRate = double.parse(exchangeRateString);

            // Ajustar el tamaño del gráfico en función del ancho de la pantalla
            double chartWidth = screenWidth -
                100.0; // Puedes ajustar el espacio según tus necesidades

            // Construye un gráfico simple con el tipo de cambio
            return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0), // Punto inicial
                      FlSpot(1, exchangeRate), // Punto con el tipo de cambio
                    ],
                    isCurved: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: const FlDotData(show: false),
                  ),
                ],
                borderData: FlBorderData(show: true),
                gridData: const FlGridData(show: false),
                minX: chartWidth,
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: non_constant_identifier_names


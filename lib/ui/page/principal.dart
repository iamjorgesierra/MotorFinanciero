import 'dart:async';
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
    baseUrl: 'https://www.alphavantage.co/query',
    apiKey: 'TJFZAYFBO0JKWQWV',
  );
  final List<double> datosSimulados = [];
  TextEditingController inversionController = TextEditingController();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _iniciarActualizacionAutomatica();
  }

  void _iniciarActualizacionAutomatica() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _obtenerDatoFinanciero();
    });
  }

  @override
  void dispose() {
    _detenerActualizacionAutomatica();
    super.dispose();
  }

  void _detenerActualizacionAutomatica() {
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Aplicación Financiera'),
        ),
        body: Column(
          children: [
            _buildCamposInversion(),
            _buildGrafica(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildCamposInversion() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: inversionController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Inversión'),
          ),
          ElevatedButton(
            onPressed: _agregarInversion,
            child: const Text('Agregar Inversión'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrafica(double screenWidth) {
    LineChartData chartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: _generarPuntosGrafica(datosSimulados),
          isCurved: true,
          barWidth: 5,
          belowBarData: BarAreaData(show: false),
        ),
      ],
      borderData: FlBorderData(show: true),
      gridData: const FlGridData(show: false),
      minX: 0,
      maxX: datosSimulados.length.toDouble() - 1,
      minY: _calcularMinY(),
      maxY: _calcularMaxY(),
    );

    return Container(
      width: screenWidth * 0.9,
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        chartData,
      ),
    );
  }

  double _calcularMinY() {
    if (datosSimulados.isEmpty) {
      return 0.0; // O el valor mínimo por defecto que desees
    } else {
      return datosSimulados
          .reduce((min, current) => min < current ? min : current);
      // Esto encontraría el valor mínimo en la lista 'datosSimulados'
    }
  }

  double _calcularMaxY() {
    if (datosSimulados.isEmpty) {
      return 0.0; // O el valor máximo por defecto que desees
    } else {
      return datosSimulados
          .reduce((max, current) => max > current ? max : current);
      // Esto encontraría el valor máximo en la lista 'datosSimulados'
    }
  }

  List<FlSpot> _generarPuntosGrafica(List<double> datos) {
    List<FlSpot> spots = [];
    for (int i = 0; i < datos.length; i++) {
      spots.add(FlSpot(i.toDouble(), datos[i]));
    }
    return spots;
  }

  void _agregarInversion() {
    double inversion = double.tryParse(inversionController.text) ?? 0.0;
    datosSimulados.add(inversion);
    setState(() {});
  }

  void _obtenerDatoFinanciero() async {
    try {
      Map<String, dynamic> datos = await _apiController.obtenerDatosFinancieros(
        function: 'TIME_SERIES_DAILY',
        symbol: 'IBM',
        outputSize: 'compact',
        dataType: 'json',
      );

      if (datos.containsKey('Time Series (Daily)') &&
          datos['Time Series (Daily)'] is Map<String, dynamic> &&
          datos['Time Series (Daily)'].isNotEmpty) {
        List<CandleData> candleDataList = [];

        datos['Time Series (Daily)'].forEach((key, value) {
          double open = double.parse(value['1. open']);
          double high = double.parse(value['2. high']);
          double low = double.parse(value['3. low']);
          double close = double.parse(value['4. close']);

          candleDataList.add(CandleData(
            open: open,
            high: high,
            low: low,
            close: close,
          ));
        });

        setState(() {
          datosSimulados.clear();
          datosSimulados.addAll(candleDataList.map((e) => e.close).toList());
        });
        print(
            "Datos actualizados: $datosSimulados"); // Añadido para verificar datos
      }
    } catch (e) {
      print('Error al obtener datos: $e'); // Manejo de errores
    }
  }

  // ignore: non_constant_identifier_names
  CandleStickBarData(
      {required List<FlSpot> spots,
      required bool isCurved,
      required int barWidth,
      required Shadow shadow,
      required int shadowWidth}) {}

  // ignore: non_constant_identifier_names
  CandleChart({required LineChartData lineChartData}) {}
}

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

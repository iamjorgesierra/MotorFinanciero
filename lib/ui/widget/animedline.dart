import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnimatedLineChart extends StatefulWidget {
  final LineChartData data;
  final Duration duration;

  const AnimatedLineChart({
    Key? key,
    required this.data,
    this.duration = const Duration(milliseconds: 300), required LineChartData lineChartData,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedLineChartState createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart> with SingleTickerProviderStateMixin {
  late LineChartData _lineChartData;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _lineChartData = widget.data;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.duration = widget.duration;

    _animateChart();
  }

  void _animateChart() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return LineChart(
          _lineChartData.copyWith(
            lineBarsData: _lineChartData.lineBarsData.map((barData) {
              final spots = barData.spots.map((spot) {
                final double x = spot.x;
                final double y = lerpDouble(0, spot.y, _animationController.value)!;
                return FlSpot(x, y);
              }).toList();
              return barData.copyWith(spots: spots);
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

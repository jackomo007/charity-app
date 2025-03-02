import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/models/charity.dart';

class DonationsChart extends StatelessWidget {
  final List<Charity> donations;

  const DonationsChart({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    List<FlSpot> dataPoints = [];
    for (int i = 0; i < donations.length; i++) {
      dataPoints.add(FlSpot(i.toDouble(), donations[i].amount.toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true))),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black, width: 1)),
        lineBarsData: [
          LineChartBarData(spots: dataPoints, isCurved: true, color: Colors.blue, barWidth: 4),
        ],
      ),
    );
  }
}
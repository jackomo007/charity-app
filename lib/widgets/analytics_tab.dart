import 'package:charity_app/widgets/impact_metric.dart';
import 'package:flutter/material.dart';
import '../core/models/charity.dart';
import '../widgets/donations_chart.dart';

class AnalyticsTab extends StatelessWidget {
  final List<Charity> donations;

  const AnalyticsTab({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};
    for (var charity in donations) {
      categoryTotals[charity.category] = (categoryTotals[charity.category] ?? 0) + charity.amount;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Donation Distribution by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(child: DonationsChart(donations: donations)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: ImpactMetric(title: "Lives Impacted", value: "${donations.length * 1.5}")),
              Expanded(child: ImpactMetric(title: "Projects Funded", value: "${donations.length ~/ 3}")),
            ],
          ),
        ],
      ),
    );
  }
}
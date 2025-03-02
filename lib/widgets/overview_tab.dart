import 'package:charity_app/widgets/metric_card.dart';
import 'package:charity_app/widgets/recent_donations.dart';
import 'package:flutter/material.dart';
import '../core/models/charity.dart';
import '../widgets/donations_chart.dart';

class OverviewTab extends StatelessWidget {
  final List<Charity> donations;

  const OverviewTab({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MetricCard(title: "Total Donations", value: "\$${donations.fold(0.0, (sum, item) => sum + item.amount)}"),
              MetricCard(title: "Active Donors", value: "${donations.length}"),
              MetricCard(title: "Causes Supported", value: "${donations.map((e) => e.category).toSet().length}"),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Donation Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(child: DonationsChart(donations: donations)),
          const SizedBox(height: 40),
          const Text('Recent Donations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: RecentDonationsList(donations: donations)),
        ],
      ),
    );
  }
}
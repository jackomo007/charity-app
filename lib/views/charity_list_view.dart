import 'package:charity_app/core/theme/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/providers.dart';

class CharityStatsScreen extends ConsumerWidget {
  const CharityStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeViewModelProvider);
              return Text(
                'Dashboard Donations',
                style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.white : Colors.black),
              );
            },
          ),
          actions: [
          Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeViewModelProvider);
              return IconButton(
                icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                onPressed: () {
                  ref.read(themeViewModelProvider.notifier).toggleTheme();
                },
              );
            },
          ),
        ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Consumer(
              builder: (context, ref, _) {
                final themeMode = ref.watch(themeViewModelProvider);
                return TabBar(
                  indicatorColor: Colors.black,
                  labelColor: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "Overview"),
                    Tab(text: "Analytics"),
                  ],
                );
              },
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            OverviewTab(),
            AnalyticsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDonationDialog(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

void _showAddDonationDialog(BuildContext context, WidgetRef ref) {
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory; // Track selected category

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar Nueva Donación"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: donorNameController,
              decoration: const InputDecoration(labelText: "Donor Name"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Select category",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                selectedCategory = value;
              },
              items: const [
                DropdownMenuItem(value: "education", child: Text("Education")),
                DropdownMenuItem(value: "healthcare", child: Text("Healthcare")),
                DropdownMenuItem(value: "environment", child: Text("Environment")),
                DropdownMenuItem(value: "poverty", child: Text("Poverty Relief")),
                DropdownMenuItem(value: "arts", child: Text("Arts & Culture")),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final donorName = donorNameController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0.0;

              if (donorName.isNotEmpty && selectedCategory != null && amount > 0) {
                await ref.read(charityViewModelProvider.notifier).createNewDonation(
                      donorName: donorName,
                      category: selectedCategory!,
                      amount: amount,
                    );

                Navigator.pop(context);
              }
            },
            child: const Text("Agregar"),
          ),
        ],
      );
    },
  );
}

class OverviewTab extends ConsumerWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charities = ref.watch(charityViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              MetricCard(title: "Total Donations", value: "\$65,920.00"),
              MetricCard(title: "Active Donors", value: "2"),
              MetricCard(title: "Causes Supported", value: "3"),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Donation Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Expanded(child: DonationsChart()),
          const SizedBox(height: 40),
          const Text('Recent Donations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: RecentDonationsList()),
        ],
      ),
    );
  }
}

class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Donation Distribution by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Expanded(child: DonationCategoryChart()),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: ImpactMetric(title: "Lives Impacted", value: "12.45")),
              Expanded(child: ImpactMetric(title: "Projects Funded", value: "89")),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const MetricCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center,),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class ImpactMetric extends StatelessWidget {
  final String title;
  final String value;
  const ImpactMetric({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class DonationsChart extends ConsumerWidget {
  const DonationsChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charities = ref.watch(charityViewModelProvider);

    if (charities.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    List<FlSpot> dataPoints = [];
    for (int i = 0; i < charities.length; i++) {
      double amount = charities[i].amount.toDouble();
      dataPoints.add(FlSpot(i.toDouble(), amount));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class RecentDonationsList extends ConsumerWidget {
  const RecentDonationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charities = ref.watch(charityViewModelProvider);

    if (charities.isEmpty) {
      return const Center(child: Text('No hay donaciones recientes'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: charities.length,
      itemBuilder: (context, index) {
        final charity = charities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(charity.donorName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(charity.category),
            trailing: Text(
              "\$${charity.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}

class DonationCategoryChart extends ConsumerWidget {
  const DonationCategoryChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charities = ref.watch(charityViewModelProvider);

    if (charities.isEmpty) {
      return const Center(child: Text('No hay datos disponibles'));
    }

    Map<String, double> categoryTotals = {};
    for (var charity in charities) {
      categoryTotals[charity.category] = (categoryTotals[charity.category] ?? 0) + charity.amount;
    }

    List<BarChartGroupData> barGroups = categoryTotals.entries.map((entry) {
      return BarChartGroupData(
        x: categoryTotals.keys.toList().indexOf(entry.key),
        barRods: [BarChartRodData(toY: entry.value, color: Colors.blue)],
      );
    }).toList();

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true))),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }
}
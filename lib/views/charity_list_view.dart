import 'package:charity_app/widgets/analytics_tab.dart';
import 'package:charity_app/widgets/overview_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/charity_stats_view_model.dart';
import '../core/theme/theme_view_model.dart';
import '../widgets/add_donation_dialog.dart';
import '../widgets/donations_chart.dart';

class CharityStatsScreen extends ConsumerWidget {
  const CharityStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeViewModelProvider);
    final donationsState = ref.watch(charityViewModelProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard Donations', style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
          actions: [
            IconButton(
              icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, color: themeMode == ThemeMode.dark ? Colors.white : Colors.black),
              onPressed: () {
                ref.read(themeViewModelProvider.notifier).toggleTheme();
              },
            ),
          ],
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Analytics"),
            ],
          ),
        ),
        body: donationsState.when(
          data: (donations) => TabBarView(
            children: [
              OverviewTab(donations: donations),
              AnalyticsTab(donations: donations),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error cargando datos: $e")),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (_) => const AddDonationDialog());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
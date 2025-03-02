import 'package:flutter/material.dart';
import '../core/models/charity.dart';

class RecentDonationsList extends StatelessWidget {
  final List<Charity> donations;

  const RecentDonationsList({super.key, required this.donations});

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(child: Text('No hay donaciones recientes'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final charity = donations[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(charity.donorName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(charity.category),
            trailing: Text("\$${charity.amount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ),
        );
      },
    );
  }
}
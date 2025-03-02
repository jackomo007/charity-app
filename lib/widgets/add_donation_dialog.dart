import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/charity_stats_view_model.dart';

class AddDonationDialog extends ConsumerStatefulWidget {
  const AddDonationDialog({super.key});

  @override
  ConsumerState<AddDonationDialog> createState() => _AddDonationDialogState();
}

class _AddDonationDialogState extends ConsumerState<AddDonationDialog> {
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
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
            onChanged: (value) => setState(() => selectedCategory = value),
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () async {
            final donorName = donorNameController.text.trim();
            final amount = double.tryParse(amountController.text) ?? 0.0;

            if (donorName.isNotEmpty && selectedCategory != null && amount > 0) {
              await ref.read(charityViewModelProvider.notifier).addDonation(
                    donorName,
                    selectedCategory!,
                    amount,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text("Agregar"),
        ),
      ],
    );
  }
}
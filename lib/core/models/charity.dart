class Charity {
  final String id;

  final String donorName;

  final String category;

  final double amount;

  final String month;

  Charity({
    required this.id,
    required this.donorName,
    required this.category,
    required this.amount,
    required this.month,
  });

  factory Charity.fromJson(Map<String, dynamic> json) {
    return Charity(
      id: json['id'] ?? '', // Ensure fallback values if null
      donorName: json['donorName'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      month: json['month'] ?? '',
    );
  }
}

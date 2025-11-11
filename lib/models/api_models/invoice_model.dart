class Invoice {
  final String id;
  final DateTime date;
  final double amount;
  final String status;
  final String plan;

  Invoice({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.plan,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      plan: json['plan'],
    );
  }
}

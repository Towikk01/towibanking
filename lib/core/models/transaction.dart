class Transaction {
  final double amount;
  final String type; 
  final String paymentMethod; 
  final String category;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.type,
    required this.paymentMethod,
    required this.category,
    required this.date,
  });
}

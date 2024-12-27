import 'package:towibanking/core/models/category.dart';

class Transaction {
  final double amount;
  final String type;
  final String paymentMethod;
  final Category category;
  final DateTime date;
  final String? comment;

  Transaction(
      {required this.amount,
      required this.type,
      required this.paymentMethod,
      required this.category,
      required this.date,
      this.comment});
}

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

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': type,
        'paymentMethod': paymentMethod,
        'category': category.toJson(),
        'date': date.toIso8601String(),
        'comment': comment,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      type: json['type'],
      paymentMethod: json['paymentMethod'],
      category: Category.fromJson(json['category']),
      date: DateTime.parse(json['date']),
      comment: json['comment'],
    );
  }
      
}

import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/category.dart';

class TransactionForm {
  String transactionType;
  String paymentMethod;
  Category selectedCategory;
  double amount;
  String comment;
  DateTime? date;

  TransactionForm({
    required this.transactionType,
    required this.paymentMethod,
    required this.selectedCategory,
    required this.amount,
    this.date,
    this.comment = '',
  });

  

  Transaction toTransaction() {
    return Transaction(
      amount: amount,
      type: transactionType,
      paymentMethod: paymentMethod,
      category: selectedCategory,
      date: date ?? DateTime.now(),
      comment: comment.isEmpty ? null : comment,
    );
  }
  
}

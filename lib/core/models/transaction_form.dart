import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';

class TransactionForm {
  String transactionType;
  String paymentMethod;
  Category selectedCategory;
  double amount;
  String comment;
  DateTime? date;
  String? id;

  TransactionForm({
    required this.transactionType,
    required this.paymentMethod,
    required this.selectedCategory,
    required this.amount,
    this.date,
    this.id,
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
      id: DateTime.now().toString(),
    );
  }

  @override
  String toString() {
    return 'TransactionForm{transactionType: $transactionType, paymentMethod: $paymentMethod, selectedCategory: $selectedCategory, amount: $amount, comment: $comment, date: $date}';
  }

  Transaction copyWith({
    String? transactionType,
    String? paymentMethod,
    Category? selectedCategory,
    double? amount,
    String? comment,
    DateTime? date,
    String? id,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      type: transactionType ?? this.transactionType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      category: selectedCategory ?? this.selectedCategory,
      date: date ?? this.date ?? DateTime.now(),
      comment: comment ?? this.comment,
      id: id ?? this.id,
    );
  }
}

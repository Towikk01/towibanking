import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class ShareableTransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String language;
  final bool isDarkTheme;

  const ShareableTransactionCard({
    Key? key,
    required this.transaction,
    required this.language,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using localized labels from AppLocalizations for the share card
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: 350,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDarkTheme ? Colors.black : Colors.white,
        border: Border.all(
          color: isDarkTheme ? AppColors.orange : Colors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Column: Labels
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.type,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(loc.payMethond,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(loc.category,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(loc.amount,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(loc.date,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Vertical Divider
          Container(
            width: 1,
            height: double.infinity,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          // Right Column: Transaction Values
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.type == 'income' ? loc.income : loc.expense,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  transaction.paymentMethod == 'cash' ? loc.cash : loc.card,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  transaction.category.localTitles?[language] ??
                      transaction.category.title,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  transaction.amount.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '${transaction.date.day}-${transaction.date.month}-${transaction.date.year}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

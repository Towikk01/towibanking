import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/balance.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class RowBalance extends ConsumerWidget {
  final bool isDarkTheme;
  final Balance balance;
  const RowBalance({super.key, required this.isDarkTheme, required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Наличные:',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.lightCream : AppColors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            '${balance.cash}',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.orange : AppColors.mint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Карта:',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.lightCream : AppColors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            '${balance.card}',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.orange : AppColors.mint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Общий:',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.lightCream : AppColors.black),
            textAlign: TextAlign.center,
          ),
          Text(
            '${balance.cash + balance.card}',
            style: TextStyle(
                fontSize: 16,
                color: isDarkTheme ? AppColors.orange : AppColors.mint),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ]);
  }
}
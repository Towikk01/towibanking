import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/balance.dart';

class BalanceModal extends ConsumerWidget {
  final Balance balance;
  const BalanceModal({super.key, required this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController cashController = TextEditingController(
        text: balance.cash == 0
            ? null
            : balance.cash
                .toStringAsFixed(balance.cash.toInt() == balance.cash ? 0 : 2));
    final TextEditingController cardController = TextEditingController(
        text: balance.card == 0
            ? null
            : balance.card
                .toStringAsFixed(balance.card.toInt() == balance.cash ? 0 : 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        const SizedBox(
          height: 5,
        ),
        const Text('Наличные:', style: TextStyle(fontSize: 20)),
        CupertinoTextField(
          controller: cashController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.all(14),
          placeholder: balance.cash.toStringAsFixed(0),
          onChanged: (value) {
            balance.cash = double.tryParse(value) ?? 0;
          },
        ),
        const Text('Карта:', style: TextStyle(fontSize: 20)),
        CupertinoTextField(
          controller: cardController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.all(14),
          placeholder: balance.card.toStringAsFixed(0),
          onChanged: (value) {
            balance.card = double.tryParse(value) ?? 0;
          },
        ),
      ],
    );
  }
}

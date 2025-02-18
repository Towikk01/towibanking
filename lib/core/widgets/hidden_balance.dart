import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:towibanking/core/riverpod/hidden_balance.dart';

class HiddenBalanceDialog extends ConsumerStatefulWidget {
  final String currency;
  const HiddenBalanceDialog({super.key, required this.currency});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesDialogState();
}

class _CategoriesDialogState extends ConsumerState<HiddenBalanceDialog> {
  @override
  Widget build(BuildContext context) {
    var hiddenBalanceProvider = ref.watch(hiddenBalanceNotifier);
    var hiddenBalance = ref.watch(hiddenBalanceNotifier.notifier);
    TextEditingController hiddenBalanceController = TextEditingController(
        text: hiddenBalanceProvider.hiddenBalance.toStringAsFixed(
            hiddenBalanceProvider.hiddenBalance.toInt() ==
                    hiddenBalanceProvider.hiddenBalance.toDouble()
                ? 0
                : 2));
    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)!.hiddenBalance,
          style: const TextStyle(fontSize: 20)),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 15,
          children: [
            Column(
              spacing: 5,
              children: [
                Text('${AppLocalizations.of(context)!.currentHiddenBalance}:',
                    style: const TextStyle(fontSize: 18)),
                Text(
                    '${hiddenBalanceProvider.hiddenBalance.toStringAsFixed(hiddenBalanceProvider.hiddenBalance.toInt() == hiddenBalanceProvider.hiddenBalance.toDouble() ? 0 : 2)} ${widget.currency}',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
            CupertinoTextField(
                style: const TextStyle(fontSize: 20),
                padding: const EdgeInsets.all(10),
                placeholder: AppLocalizations.of(context)!.hiddenBalance,
                onChanged: (value) {
                  double newValue;
                  if (value == '') {
                    newValue = 0.0;
                  } else {
                    newValue = double.parse(value);
                  }
                  hiddenBalance.updateHiddenBalance(newValue);
                }),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context)!.change),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}

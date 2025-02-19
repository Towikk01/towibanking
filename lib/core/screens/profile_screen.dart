import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/widgets/finance_charts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Профиль"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://avatar.iran.liara.run/public',
                      scale: 1,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Тоха Тестерович",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "email@example.com",
                        style: TextStyle(
                            fontSize: 16, color: CupertinoColors.systemGrey),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text("Редактировать профиль"),
                        onPressed: () {
                          // Логика редактирования
                        },
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FinanceChartsWidget(transactions: transactions),
            ],
          ),
        ),
      ),
    );
  }
}

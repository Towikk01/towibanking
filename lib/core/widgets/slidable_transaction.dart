import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:towibanking/core/helpers/functions.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/models/transaction.dart';
import 'package:towibanking/core/riverpod/currency.dart';
import 'package:towibanking/core/riverpod/language.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/riverpod/transaction.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:towibanking/core/widgets/shareable_transaction_cart.dart';

class TransactionWidget extends ConsumerStatefulWidget {
  final String locale;
  final Transaction transaction;
  final List<Category> categories;

  const TransactionWidget({
    Key? key,
    required this.transaction,
    required this.categories,
    this.locale = 'ru',
  }) : super(key: key);

  @override
  ConsumerState<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends ConsumerState<TransactionWidget> {
  // GlobalKey for the share widget
  final GlobalKey _shareKey = GlobalKey();

  String _formattedDate(DateTime date, String language) {
    return DateFormat('d MMM yyyy', language).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider).brightness == Brightness.dark;
    final currency = ref.watch(currencyProvider)['selectedCurrency'];
    final language = ref.watch(languageNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    String formatTransactionDetails(Transaction transaction) {
      final StringBuffer buffer = StringBuffer();
      buffer.writeln(AppLocalizations.of(context)!.details);
      buffer.writeln(
          '${AppLocalizations.of(context)!.amount} \$${transaction.amount.toStringAsFixed(2)}');
      buffer.writeln(
          '${AppLocalizations.of(context)!.type}: ${transaction.type == 'income' ? AppLocalizations.of(context)!.income : AppLocalizations.of(context)!.expense}');
      buffer.writeln(
          '${AppLocalizations.of(context)!.payMethond}: ${transaction.paymentMethod == 'cash' ? AppLocalizations.of(context)!.cash : AppLocalizations.of(context)!.card}');
      buffer.writeln(
          '${AppLocalizations.of(context)!.category}: ${transaction.category.localTitles?[language] ?? transaction.category.title}');
      buffer.writeln(
          '${AppLocalizations.of(context)!.date} ${transaction.date.toLocal().toString().split(' ')[0]}');
      if (transaction.comment != null &&
          transaction.comment!.trim().isNotEmpty) {
        buffer.writeln('Comment: ${transaction.comment}');
      }

      return buffer.toString();
    }

    return Stack(
      children: [
        // Visible Transaction Card with Slidable actions
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                // Instead of pushing a new route, share image directly
                SlidableAction(
                  spacing: 2,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: (context) {
                    // Optionally, show a dialog preview if needed.
                    Share.share(formatTransactionDetails(widget.transaction));
                  },
                  backgroundColor: AppColors.secondary,
                  foregroundColor: CupertinoColors.white,
                  icon: CupertinoIcons.share,
                  label: loc.share,
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  spacing: 2,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: (context) {
                    ref
                        .watch(transactionProvider.notifier)
                        .removeTransaction(widget.transaction, ref, context);
                  },
                  backgroundColor: AppColors.orange,
                  foregroundColor: CupertinoColors.white,
                  icon: CupertinoIcons.delete,
                  label: loc.remove,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                showTransactionDialog(
                  context,
                  ref,
                  widget.categories,
                  widget.transaction,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary, width: 1),
                  borderRadius: BorderRadius.circular(16),
                  color: isDarkTheme
                      ? AppColors.black
                      : CupertinoColors.systemGrey6,
                ),
                child: CupertinoListTile(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  leading: Icon(
                    widget.transaction.category.icon,
                    color: widget.transaction.type == 'income'
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                    size: 34,
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        widget.transaction.type == 'income'
                            ? CupertinoIcons.add_circled
                            : CupertinoIcons.minus_circled,
                        color: widget.transaction.type == 'income'
                            ? CupertinoColors.systemGreen
                            : CupertinoColors.systemRed,
                        size: 36,
                      ),
                      Text(
                        _formattedDate(widget.transaction.date, language),
                        style: TextStyle(
                          color: isDarkTheme
                              ? AppColors.lightCream
                              : CupertinoColors.activeGreen,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.transaction.amount.toStringAsFixed(widget.transaction.amount == widget.transaction.amount.toInt() ? 0 : 2)} $currency',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          color: isDarkTheme
                              ? AppColors.orange
                              : CupertinoColors.activeGreen,
                        ),
                      ),
                      Text(
                        widget.transaction.category.localTitles?[language] ??
                            widget.transaction.category.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkTheme
                              ? AppColors.lightCream
                              : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.transaction.type == 'income' ? loc.income : loc.expense} - ${widget.transaction.paymentMethod == 'cash' ? loc.cash : loc.card}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme
                              ? AppColors.lightCream
                              : AppColors.black,
                        ),
                      ),
                      if (widget.transaction.comment != null)
                        Text(
                          widget.transaction.comment!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Use Visibility (instead of Offstage) so that the widget is painted but not shown.
        Visibility(
          visible: false,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: RepaintBoundary(
            key: _shareKey,
            child: ShareableTransactionCard(
              transaction: widget.transaction,
              language: language,
              isDarkTheme: isDarkTheme,
            ),
          ),
        ),
      ],
    );
  }
}

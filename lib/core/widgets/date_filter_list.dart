import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class DateFilterList extends ConsumerWidget {
  final Function(String) onPressed;
  final bool isDarkTheme;
  final String filterByDate;
  final Map<String, dynamic> filterForDate;
  const DateFilterList(
      {super.key,
      required this.onPressed,
      required this.filterByDate,
      required this.isDarkTheme,
      required this.filterForDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filterForDate.entries.map((entry) {
          return CupertinoButton(
            sizeStyle: CupertinoButtonSize.medium,
            child: Text(entry.key,
                style: TextStyle(
                    color: filterByDate == entry.key
                        ? (isDarkTheme ? AppColors.lightCream : AppColors.black)
                        : AppColors.secondary)),
            onPressed: () {
              onPressed(entry.key);
            },
          );
        }).toList(),
      ),
    );
  }
}

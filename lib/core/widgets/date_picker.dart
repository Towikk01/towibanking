import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class DatePicker extends ConsumerWidget {
  final Function(DateTime) onChanged;
  DateTime customDate;
  final bool isDarkTheme;
  DatePicker({
    super.key,
    required this.onChanged,
    required this.customDate,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CupertinoColors.transparent),
      height: 50,
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CupertinoDatePicker(
          itemExtent: 50,
          backgroundColor: CupertinoColors.transparent,
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            onChanged(newDate);
          },
        ),
      ),
    );
  }
}

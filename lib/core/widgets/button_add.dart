import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/helpers/functions.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class ButtonAdd extends ConsumerWidget {
  final List<Category> categories;
  const ButtonAdd({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoButton.filled(
      borderRadius: BorderRadius.circular(30),
      padding: const EdgeInsets.all(16),
      child: const Icon(
        CupertinoIcons.add,
        color: AppColors.lightCream,
      ),
      onPressed: () {
        showTransactionDialog(context, ref, categories, null);
      },
    );
  }
}

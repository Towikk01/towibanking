import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/theme/app_colors.dart';

class ResetButton extends ConsumerWidget {
  final VoidCallback reset;
  const ResetButton({super.key, required this.reset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoButton.filled(
      borderRadius: BorderRadius.circular(30),
      padding: const EdgeInsets.all(16),
      child: const Icon(
        CupertinoIcons.refresh,
        color: AppColors.lightCream,
      ),
      onPressed: () {
        reset();
      },
    );
  }
}

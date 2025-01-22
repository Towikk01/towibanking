import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/category.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemoveCategory extends ConsumerStatefulWidget {
  const RemoveCategory({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RemoveCategoryState();
}

class _RemoveCategoryState extends ConsumerState<RemoveCategory> {
  final Category category = Category(
    title: '',
    type: 'expense',
  );
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(unifiedCategoriesProvider.notifier);
    final categories = ref.watch(unifiedCategoriesProvider);

    return CupertinoAlertDialog(
      title: Text(AppLocalizations.of(context)!.removeCategory,
          style: const TextStyle(fontSize: 20)),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 10,
          children: [
            CupertinoTextField(
                controller: _controller,
                style: const TextStyle(fontSize: 20),
                padding: const EdgeInsets.all(10),
                placeholder: AppLocalizations.of(context)!.titleOfCategory,
                onChanged: (value) {
                  setState(() {
                    category.title = value;
                  });
                }),
            SizedBox(
              width: double.infinity,
              child: CupertinoSegmentedControl<String>(
                padding: EdgeInsets.zero,
                children: {
                  'expense': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppLocalizations.of(context)!.expense,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  'income': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppLocalizations.of(context)!.income,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20)),
                  ),
                },
                groupValue: category.type,
                onValueChanged: (value) {
                  setState(() {
                    category.type = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context)!.remove),
          onPressed: () {
            final existingCategory = categories.firstWhere(
              (c) => c.title == category.title && c.type == category.type,
              orElse: () => Category(
                  title: '', type: 'expense'), // Default empty category
            );

           if (existingCategory.title.isEmpty &&
                existingCategory.type == 'expense') {
              // If no valid category is found, show the error dialog
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: Text(AppLocalizations.of(context)!.error),
                  content: Text(AppLocalizations.of(context)!.categoryNotFound),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              // Если категория найдена, удаляем её
              if (category.title.isNotEmpty && category.type != null) {
                categoryProvider.removeCategory(category);
                Navigator.of(context, rootNavigator: true).pop();
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(AppLocalizations.of(context)!.error),
                    content: Text(AppLocalizations.of(context)!.completeFields),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

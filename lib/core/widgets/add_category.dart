import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/category.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesDialog extends ConsumerStatefulWidget {
  final Category form;
  final List<IconData> icons;
  final VoidCallback add;
  const CategoriesDialog(
      {super.key, required this.icons, required this.form, required this.add});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesDialogState();
}

class _CategoriesDialogState extends ConsumerState<CategoriesDialog> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(unifiedCategoriesProvider);
    return CupertinoAlertDialog(
      title: const Text("Добавить категорию", style: TextStyle(fontSize: 20)),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 10,
          children: [
            CupertinoTextField(
              style: const TextStyle(fontSize: 20),
              padding: const EdgeInsets.all(14),
              placeholder: "Название категории",
              onChanged: (value) {
                widget.form.title = value;
                setState(() {
                  widget.form.title = value;
                });
              },
            ),
            SizedBox(
              child: CupertinoSegmentedControl<String>(
                padding: const EdgeInsets.all(10),
                children: {
                  'expense': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppLocalizations.of(context)!.expense,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  'income': Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(AppLocalizations.of(context)!.income,
                        style: const TextStyle(fontSize: 20)),
                  ),
                },
                groupValue: widget.form.type,
                onValueChanged: (value) {
                  widget.form.type = value;
                  setState(() {
                    widget.form.type = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: CupertinoPicker(
                itemExtent: 50,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    widget.form.icon = widget.icons[index];
                  });
                },
                children: widget.icons.map((icon) => Icon(icon)).toList(),
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
          child: Text(AppLocalizations.of(context)!.add),
          onPressed: () {
            if (categories.any((el) =>
                el.title == widget.form.title && el.type == widget.form.type)) {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Ошибка"),
                  content: const Text("Категория уже существует"),
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
              return;
            }
            if (widget.form.title.isNotEmpty && widget.form.icon != null) {
              widget.add();
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Ошибка"),
                  content: const Text("Заполните все поля"),
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
          },
        ),
      ],
    );
  }
}

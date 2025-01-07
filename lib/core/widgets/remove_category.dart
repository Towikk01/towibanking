import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/category.dart';

class RemoveCategory extends ConsumerStatefulWidget {
  const RemoveCategory({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RemoveCategoryState();
}

class _RemoveCategoryState extends ConsumerState<RemoveCategory> {
  final Category category = Category(title: '', type: 'expense');
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(unifiedCategoriesProvider.notifier);
    return CupertinoAlertDialog(
      title: const Text("Удалить категорию", style: TextStyle(fontSize: 20)),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 10,
          children: [
            CupertinoTextField(
                controller: _controller,
                style: const TextStyle(fontSize: 20),
                padding: const EdgeInsets.all(14),
                placeholder: "Название категории",
                onChanged: (value) {
                  setState(() {
                    category.title = value;
                  });
                }),
            SizedBox(
              child: CupertinoSegmentedControl<String>(
                padding: const EdgeInsets.all(10),
                children: {
                  'expense': Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('Расход', style: TextStyle(fontSize: 20)),
                  ),
                  'income': Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text('Приход', style: TextStyle(fontSize: 20)),
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
          child: const Text("Отмена"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        CupertinoDialogAction(
          child: const Text("Удалить"),
          onPressed: () {
            if (category.title.isNotEmpty && category.type != null) {
              categoryProvider.removeCategory(category);
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

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/category.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<IconData> cupertinoIcons = [
    CupertinoIcons.add,
    CupertinoIcons.airplane,
    CupertinoIcons.alarm,
    CupertinoIcons.arrow_down,
    CupertinoIcons.arrow_up,
    CupertinoIcons.book,
    CupertinoIcons.calendar,
    CupertinoIcons.camera,
    CupertinoIcons.chat_bubble,
    CupertinoIcons.check_mark,
    CupertinoIcons.heart,
    CupertinoIcons.home,
    CupertinoIcons.mail,
    CupertinoIcons.map,
    CupertinoIcons.music_note,
    CupertinoIcons.person,
    CupertinoIcons.search,
    CupertinoIcons.settings,
    CupertinoIcons.shopping_cart,
    CupertinoIcons.trash,
    CupertinoIcons.video_camera,
    CupertinoIcons.volume_up,
    CupertinoIcons.xmark
  ];

  final Category form =
      Category(title: '', icon: null, id: '', type: 'expense');

  void _addCategory() {
    final notifier = ref.read(unifiedCategoriesProvider.notifier);
    notifier.addCategory(Category(
      title: form.title,
      icon: form.icon,
      id: DateTime.now().toIso8601String(),
      type: form.type,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Настройки"),
      ),
      child: ListView(
        children: [
          CupertinoListTile(
            title: const Text("Темная тема"),
            trailing: CupertinoSwitch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          CupertinoListTile(
            title: const Text("Валюта"),
            trailing: CupertinoButton(
              child: const Text("UAH"),
              onPressed: () {},
            ),
          ),
          CupertinoListTile(
            title: const Text("Добавить категорию"),
            trailing: CupertinoButton(
              child: const Text("+"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return CupertinoAlertDialog(
                      title: const Text("Добавить категорию",
                          style: TextStyle(fontSize: 20)),
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
                                setState(() {
                                  form.title = value;
                                });
                              },
                            ),
                            CupertinoSegmentedControl<String>(
                              padding: const EdgeInsets.all(10),
                              children: {
                                'expense': Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Text('Расход',
                                        style: TextStyle(fontSize: 20))),
                                'income': Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Text('Приход',
                                        style: TextStyle(fontSize: 20))),
                              },
                              onValueChanged: (value) {
                                setState(() {
                                  form.type = value;
                                  print('Selected type: $value');
                                });
                              },
                              groupValue: form.type,
                            ),
                            SizedBox(
                              height: 50,
                              child: CupertinoPicker(
                                itemExtent: 50,
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    form.icon = cupertinoIcons[index];
                                  });
                                },
                                children: cupertinoIcons
                                    .map((icon) => Icon(icon))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("Отмена"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: false).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: const Text("Добавить"),
                          onPressed: () {
                            if (form.title.isNotEmpty && form.icon != null) {
                              _addCategory();
                              Navigator.of(context, rootNavigator: false).pop();
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
                  },
                );
              },
            ),
          ),
          CupertinoListTile(
            title: const Text(
              "Очистить все данные",
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:towibanking/core/models/category.dart';
import 'package:towibanking/core/riverpod/category.dart';
import 'package:towibanking/core/widgets/add_category.dart';
import 'package:towibanking/core/widgets/remove_category.dart';

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

  late Category form;

  @override
  void initState() {
    super.initState();
    form = Category(
        title: '', icon: cupertinoIcons.first, id: '', type: 'expense');
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(unifiedCategoriesProvider.notifier);
    void addCategory() {
      final newCategory = Category(
          title: form.title,
          icon: form.icon,
          id: DateTime.now().toIso8601String(),
          type: form.type);
      notifier.addCategory(newCategory);
    }

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
                    return CategoriesDialog(
                      form: form,
                      cupertinoIcons: cupertinoIcons,
                      add: addCategory,
                    );
                  },
                );
              },
            ),
          ),
          CupertinoListTile(
            title: const Text("Удалить категорию"),
            trailing: CupertinoButton(
              child: const Text("-"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return const RemoveCategory();
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Профиль"),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(''), // или NetworkImage
            ),
            const SizedBox(height: 20),
            const Text(
              "Тоха Тестерович", // можно подтянуть из модели
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "email@example.com", // можно подтянуть из модели
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              child: const Text("Редактировать профиль"),
              onPressed: () {
                // Логика редактирования
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:towibanking/core/widgets/tab_bar.dart';

void main() async {
  await initializeDateFormatting('ru', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      locale: Locale('ru'),
      title: 'Towibanking',
      localizationsDelegates: [
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: AppColors.orange,
          barBackgroundColor: AppColors.black,
          scaffoldBackgroundColor: AppColors.black,
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(color: AppColors.orange),
            primaryColor: CupertinoColors.black,
          )),
      home: TabBar(),
    );
  }
}

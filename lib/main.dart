import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:towibanking/core/riverpod/theme.dart';
import 'package:towibanking/core/theme/app_colors.dart';
import 'package:towibanking/core/widgets/tab_bar.dart';

void main() async {
  await initializeDateFormatting('ru', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return CupertinoApp(
      locale: const Locale('ru'),
      title: 'Towibanking',
      localizationsDelegates: const [
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const TabBar(),
    );
  }
}

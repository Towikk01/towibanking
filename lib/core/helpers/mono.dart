import 'package:monobank_api/monobank_api.dart';

void getMono(String token) async {
  var client = MonoAPI(token);
  var res = await client.clientInfo();
  // print(client);
  // print(res);
  var account = res.accounts
      .where((account) => account.balance.currency == Currency.code('UAH'))
      .first;
  // print(account);
  var statement = account.statement(
    DateTime.now().subtract(Duration(days: 90)),
    DateTime.now(),
  );

  await for (var item in statement.list(isReverseChronological: true)) {
    // print('$item');
  }
}

import 'package:flutter_test/flutter_test.dart';

import '../core/models/currency_rate.dart';
import '../core/services/exchange_api.dart';

void main() {
  test('convert EGP to USD with mock rates', () {
    final api = ExchangeApi();
    // simulate rates where 1 USD = 47 EGP
    final rates = CurrencyRate(base: 'USD', rates: {'EGP': 47.0, 'USD': 1.0}, fetchedAt: DateTime.now());
    final amountEgp = 470.0;
    final converted = api.convert(amount: amountEgp, from: 'EGP', to: 'USD', rates: rates);
    // 470 EGP -> 10 USD
    expect(converted, closeTo(10.0, 0.001));
  });
}

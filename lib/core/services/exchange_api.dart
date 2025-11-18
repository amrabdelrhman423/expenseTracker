import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_rate.dart';

class ExchangeApi {

  final http.Client client;
  ExchangeApi({http.Client? client}) : client = client ?? http.Client();

  // fetch latest rates with base USD
  Future<CurrencyRate> fetchLatestRates({String base = 'USD'}) async {
    final uri = Uri.parse('https://open.er-api.com/v6/latest/$base');

    final resp = await client.get(uri).timeout(Duration(seconds: 10));

    if (resp.statusCode != 200) {
      throw Exception('Rate fetch failed');
    }

    final data = jsonDecode(resp.body);

    final rates = Map<String, double>.from(
      (data['rates'] as Map).map(
            (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
      ),
    );

    return CurrencyRate(
      base: base,
      rates: rates,
      fetchedAt: DateTime.now(),
    );
  }

  double convert({required double amount, required String from, required String to, required CurrencyRate rates}) {
    // convert from 'from' to 'to' using rates where base == rates.base
    if (from == to) return amount;
    if (from == rates.base) {
      // amount in base -> multiply by rates[to]
      final r = rates.rates[to] ?? (throw Exception('No rate for $to'));
      return amount * r;
    } else if (to == rates.base) {
      // amount in currency -> divide by rates[from]
      final rFrom = rates.rates[from] ?? (throw Exception('No rate for $from'));
      return amount / rFrom;
    } else {
      // convert via base: from->base->to
      final toBase = amount / (rates.rates[from] ?? (throw Exception('No rate for $from')));
      return toBase * (rates.rates[to] ?? (throw Exception('No rate for $to')));
    }
  }

}

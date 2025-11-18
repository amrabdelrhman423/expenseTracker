class CurrencyRate {
  final String base; // e.g. "USD"
  final Map<String,double> rates;
  final DateTime fetchedAt;

  CurrencyRate({required this.base, required this.rates, required this.fetchedAt});
}

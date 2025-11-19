import 'package:flutter/cupertino.dart';

import '../services/local_storage_service.dart';
import '../services/exchange_api.dart';
import '../models/expense.dart';
import '../models/currency_rate.dart';
import 'package:uuid/uuid.dart';

class ExpenseRepository {

  final LocalStorageService local;
  final ExchangeApi api;
  CurrencyRate? cachedRates;

  ExpenseRepository({required this.local, required this.api});

  Future<Expense> addExpense({
    required String categoryId,
    required double amount,
    required String currency,
    required DateTime date,
    String? receiptPath,
  }) async {
    // ensure we have rates
    debugPrint("cachedRates: $cachedRates");
    final rates = cachedRates ?? await api.fetchLatestRates(base: 'USD').then((r){ cachedRates = r; return r; });
    debugPrint("rates: $rates");

    final converted = api.convert(amount: amount, from: currency, to: 'USD', rates: rates!);

    final id = Uuid().v4();

    final expense = Expense(
      id: id,
      categoryId: categoryId,
      amount: amount,
      currency: currency,
      convertedAmountUSD: converted,
      date: date,
      receiptPath: receiptPath,
    );
    await local.addExpense(expense);
    return expense;
  }

  Future<List<Expense>> fetchExpensesPage({required int page, int pageSize = 10, DateTime? from, DateTime? to}) {
    return local.getExpenses(page: page, pageSize: pageSize, from: from, to: to);
  }

  Future<int> totalCount({DateTime? from, DateTime? to}) => local.totalCount(from: from, to: to);

  // Get all expenses for summary calculation
  Future<List<Expense>> getAllExpenses({DateTime? from, DateTime? to}) {
    return local.getAllExpenses(from: from, to: to);
  }
}

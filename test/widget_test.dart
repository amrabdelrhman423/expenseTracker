import 'package:expense_tracker/core/models/expense.dart';
import 'package:expense_tracker/core/repositories/expense_repository.dart';
import 'package:expense_tracker/core/services/exchange_api.dart';
import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/dashboard/bloc/expense_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockLocalStorage extends Mock implements LocalStorageService {}
class MockExchangeApi extends Mock implements ExchangeApi {}

void main() {
  late ExpenseRepository repo;
  late MockLocalStorage local;
  late MockExchangeApi api;
  late ExpenseBloc bloc;

  setUp(() {
    local = MockLocalStorage();
    api = MockExchangeApi();
    repo = ExpenseRepository(local: local, api: api);
    bloc = ExpenseBloc(repo: repo);
  });

  test('pagination loads pages correctly', () async {
    // Mock first page
    when(() => local.getExpenses(page: 0, pageSize: 10, from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async => List.generate(10, (i) => Expense(
      id: 'id_$i',
      categoryId: 'cat1',
      amount: 100,
      currency: 'EGP',
      convertedAmountUSD: 3,
      date: DateTime.now(),
    )));

    // Mock second page
    when(() => local.getExpenses(page: 1, pageSize: 10, from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async => List.generate(5, (i) => Expense(
      id: 'id_more_$i',
      categoryId: 'cat2',
      amount: 50,
      currency: 'EGP',
      convertedAmountUSD: 1.5,
      date: DateTime.now(),
    )));

    // Mock totalCount
    when(() => local.totalCount(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async => 15);

    // Mock getAllExpenses (for summary)
    when(() => local.getAllExpenses(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async => List.generate(15, (i) => Expense(
      id: 'e_$i',
      categoryId: 'cat',
      amount: 100,
      currency: 'EGP',
      convertedAmountUSD: 3,
      date: DateTime.now(),
    )));

    // ---- LOAD FIRST PAGE ----
    bloc.add(LoadExpenses());
    await Future.delayed(Duration(milliseconds: 50));

    expect(bloc.state, isA<ExpenseLoaded>());
    final firstState = bloc.state as ExpenseLoaded;
    expect(firstState.expenses.length, 10);
    expect(firstState.hasMore, true);

    // ---- LOAD MORE PAGE ----
    bloc.add(LoadMoreExpenses());
    await Future.delayed(Duration(milliseconds: 50));

    final nextState = bloc.state as ExpenseLoaded;
    expect(nextState.expenses.length, 15);
    expect(nextState.hasMore, false);
  });
}

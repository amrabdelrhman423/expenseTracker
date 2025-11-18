import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/expense.dart';
import '../../../core/repositories/expense_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repo;
  static const int pageSize = 10;

  ExpenseBloc({required this.repo}) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<RefreshExpenses>(_onRefreshExpenses);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());

    try {
      final page = 0;

      // Fetch paginated items
      final items = await repo.fetchExpensesPage(
        page: page,
        pageSize: pageSize,
        from: event.from,
        to: event.to,
      );

      final total = await repo.totalCount(
        from: event.from,
        to: event.to,
      );

      final hasMore = items.length + page * pageSize < total;

      // Fetch ALL filtered items to calculate summary
      final allExpenses =
      await repo.getAllExpenses(from: event.from, to: event.to);

      // ---------------------------
      // 🔥 CALCULATE SUMMARY
      // ---------------------------

      // Total Expenses (EGP)
      final totalExpensesEGP =
      allExpenses.fold<double>(0, (sum, e) => sum + e.amount);

      // Total Expenses (USD)
      final totalExpensesUSD =
      allExpenses.fold<double>(0, (sum, e) => sum + e.convertedAmountUSD);

      // If you add income later, adjust these:
      final totalIncomeEGP = 471983.0;
      final totalIncomeUSD = 10000.0;

      // TOTAL BALANCE
      final totalBalanceEGP = totalIncomeEGP - totalExpensesEGP;
      final totalBalanceUSD = totalIncomeUSD - totalExpensesUSD;

      emit(ExpenseLoaded(
        expenses: items,
        page: page,
        hasMore: hasMore,

        /// Summary values
        totalExpensesEGP: totalExpensesEGP,
        totalExpensesUSD: totalExpensesUSD,
        totalIncomeEGP: totalIncomeEGP,
        totalIncomeUSD: totalIncomeUSD,
        totalBalanceEGP: totalBalanceEGP,
        totalBalanceUSD: totalBalanceUSD,
      ));

    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreExpenses(
      LoadMoreExpenses event, Emitter<ExpenseState> emit) async {
    final current = state;

    if (current is ExpenseLoaded &&
        !current.isLoadingMore &&
        current.hasMore) {
      emit(current.copyWith(isLoadingMore: true));

      try {
        final nextPage = current.page + 1;

        final items = await repo.fetchExpensesPage(
          page: nextPage,
          pageSize: pageSize,
          from: event.from,
          to: event.to,
        );

        final all = List<Expense>.from(current.expenses)..addAll(items);

        final total = await repo.totalCount(
          from: event.from,
          to: event.to,
        );

        final hasMore = all.length < total;

        emit(current.copyWith(
          expenses: all,
          page: nextPage,
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(ExpenseError(message: e.toString()));
      }
    }
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    try {
      await repo.addExpense(
        categoryId: event.categoryId,
        amount: event.amount,
        currency: event.currency,
        date: event.date,
        receiptPath: event.receiptPath,
      );

      // Reload with filters
      add(LoadExpenses(from: event.from, to: event.to));
    } catch (e) {
      emit(ExpenseError(message: e.toString()));
    }
  }

  Future<void> _onRefreshExpenses(
      RefreshExpenses event, Emitter<ExpenseState> emit) async {
    add(LoadExpenses(from: event.from, to: event.to));
  }
}

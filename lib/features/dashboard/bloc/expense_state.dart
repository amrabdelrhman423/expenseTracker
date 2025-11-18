part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  /// SUMMARY VALUES
  final double totalExpensesEGP;
  final double totalExpensesUSD;

  final double totalIncomeEGP;
  final double totalIncomeUSD;

  final double totalBalanceEGP;
  final double totalBalanceUSD;

  ExpenseLoaded({
    required this.expenses,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    required this.totalExpensesEGP,
    required this.totalExpensesUSD,
    required this.totalIncomeEGP,
    required this.totalIncomeUSD,
    required this.totalBalanceEGP,
    required this.totalBalanceUSD,
  });

  ExpenseLoaded copyWith({
    List<Expense>? expenses,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    double? totalExpensesEGP,
    double? totalExpensesUSD,
    double? totalIncomeEGP,
    double? totalIncomeUSD,
    double? totalBalanceEGP,
    double? totalBalanceUSD,
  }) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalExpensesEGP: totalExpensesEGP ?? this.totalExpensesEGP,
      totalExpensesUSD: totalExpensesUSD ?? this.totalExpensesUSD,
      totalIncomeEGP: totalIncomeEGP ?? this.totalIncomeEGP,
      totalIncomeUSD: totalIncomeUSD ?? this.totalIncomeUSD,
      totalBalanceEGP: totalBalanceEGP ?? this.totalBalanceEGP,
      totalBalanceUSD: totalBalanceUSD ?? this.totalBalanceUSD,
    );
  }

  @override
  List<Object?> get props => [
    expenses,
    page,
    hasMore,
    isLoadingMore,
    totalExpensesEGP,
    totalExpensesUSD,
    totalIncomeEGP,
    totalIncomeUSD,
    totalBalanceEGP,
    totalBalanceUSD,
  ];
}

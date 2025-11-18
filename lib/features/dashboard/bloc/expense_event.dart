part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadExpenses({this.from, this.to});
}

class LoadMoreExpenses extends ExpenseEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadMoreExpenses({this.from, this.to});
}

class AddExpenseEvent extends ExpenseEvent {
  final String categoryId;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;
  final DateTime? from; // optional filter used to reload properly
  final DateTime? to;

  AddExpenseEvent({
    required this.categoryId,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
    this.from,
    this.to,
  });

  @override List<Object?> get props => [categoryId, amount, currency, date, receiptPath];
}

class RefreshExpenses extends ExpenseEvent {
  final DateTime? from;
  final DateTime? to;
  RefreshExpenses({this.from, this.to});
}

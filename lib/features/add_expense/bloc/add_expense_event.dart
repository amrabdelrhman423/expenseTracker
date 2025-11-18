part of 'add_expense_bloc.dart';

abstract class AddExpenseEvent {}

class SubmitExpense extends AddExpenseEvent {
  final String categoryId;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;

  SubmitExpense({
    required this.categoryId,
    required this.amount,
    required this.currency,
    required this.date,
    required this.receiptPath,
  });
}

part of 'add_expense_bloc.dart';

abstract class AddExpenseState {}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseSuccess extends AddExpenseState {}

class AddExpenseError extends AddExpenseState {
  final String message;

  AddExpenseError(this.message);
}

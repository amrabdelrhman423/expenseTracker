import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/expense_repository.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final ExpenseRepository repo;

  AddExpenseBloc({required this.repo}) : super(AddExpenseInitial()) {
    on<SubmitExpense>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitExpense event, Emitter<AddExpenseState> emit) async {
    emit(AddExpenseLoading());

    try {
      await repo.addExpense(
        categoryId: event.categoryId,
        amount: event.amount,
        currency: event.currency,
        date: event.date,
        receiptPath: event.receiptPath,
      );

      emit(AddExpenseSuccess());
    } catch (e) {
      emit(AddExpenseError(e.toString()));
    }
  }
}

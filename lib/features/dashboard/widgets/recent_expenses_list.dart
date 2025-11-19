import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/categories.dart';
import '../../../core/models/expense.dart';
import '../bloc/expense_bloc.dart';


class RecentExpensesList extends StatelessWidget {
   const RecentExpensesList({super.key , required this.from , required this.to ,required this.expenses , required this.state , required this.scrollController});

  final ExpenseState state;

  final DateTime? from;
  final DateTime? to;
  final List<Expense> expenses;
  final ScrollController scrollController;

@override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ExpenseBloc>().add(
            RefreshExpenses(from: from, to: to),
          );
        },
        child: expenses.isEmpty
            ? _emptyExpenses()
            : _listExpenses(state, expenses),
      ),
    );
  }

  Widget _emptyExpenses() => SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: SizedBox(
      height: 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text("No expenses yet", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
            SizedBox(height: 8.h),
            Text("Tap the + button to add your first expense",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          ],
        ),
      ),
    ),
  );

  Widget _listExpenses(state, expenses) => ListView.builder(
    controller: scrollController,
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    itemCount: expenses.length + (state.hasMore ? 1 : 0),
    itemBuilder: (context, idx) {
      if (idx >= expenses.length) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final expense = expenses[idx];
      final category =
      CategoryConstants.getCategoryById(expense.categoryId);
      final icon = category != null
          ? CategoryConstants.getIconData(category.iconName)
          : Icons.category;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: CategoryConstants.getCategoryColor(category?.iconName ?? '').withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                color: CategoryConstants.getCategoryColor(category?.iconName ?? ''),
                size: 28.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category?.title ?? expense.categoryId,
                      style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 6.h),
                  Text("Manually",
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("\$${expense.convertedAmountUSD.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.red)),
                Text("${getCurrencySymbol(expense.currency)}${expense.amount}",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.red)),
                SizedBox(height: 6.h),
                Text(_formatDate(expense.date),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      );
    },
  );

  String _formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expenseDay = DateTime(date.year, date.month, date.day);

  if (expenseDay == today) {
    return "Today ${DateFormat('h:mm a').format(date)}";
  } else if (expenseDay == today.subtract(Duration(days: 1))) {
    return "Yesterday ${DateFormat('h:mm a').format(date)}";
  }
  return DateFormat('MMM d, h:mm a').format(date);
}

   String getCurrencySymbol(String currency) {
     switch (currency.toUpperCase()) {
       case 'USD':
         return '\$';
       case 'EGP':
         return 'E£';
       case 'EUR':
         return '€';
       case 'GBP':
         return '£';
       case 'SAR':
         return '﷼';
       default:
         return currency; // fallback
     }
   }

}

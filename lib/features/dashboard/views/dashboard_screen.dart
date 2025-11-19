import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/expense_bloc.dart';
import '../../../core/models/expense.dart';
import '../../../core/constants/categories.dart';
import 'package:intl/intl.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/recent_expenses_list.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String filter = 'This Month';

  DateTime? _filterFrom;
  DateTime? _filterTo;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _applyFilter(filter);
    _scrollController.addListener(_onScroll);
    context.read<ExpenseBloc>().add(LoadExpenses(from: _filterFrom, to: _filterTo));
  }

  void _applyFilter(String f) {
    setState(() {
      filter = f;
      final now = DateTime.now();

      if (f == 'This Month') {
        _filterFrom = DateTime(now.year, now.month, 1);
        _filterTo = DateTime(now.year, now.month + 1, 1)
            .subtract(Duration(seconds: 1));
      } else if (f == 'Last 7 Days') {
        _filterFrom = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: 6));
        _filterTo = DateTime(now.year, now.month, now.day + 1)
            .subtract(Duration(seconds: 1));
      } else {
        _filterFrom = null;
        _filterTo = null;
      }
    });

    context.read<ExpenseBloc>().add(
      LoadExpenses(from: _filterFrom, to: _filterTo),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= (max - 200.h)) {
      final state = context.read<ExpenseBloc>().state;
      if (state is ExpenseLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<ExpenseBloc>().add(
          LoadMoreExpenses(from: _filterFrom, to: _filterTo),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text("Error: ${state.message}", style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(
                        LoadExpenses(from: _filterFrom, to: _filterTo),
                      );
                    },
                    child: Text("Retry", style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          }

          final expenses = state is ExpenseLoaded ? state.expenses : <Expense>[];

          final totalBalanceUSD = state is ExpenseLoaded ? state.totalBalanceUSD : 0.0;
          final totalBalanceEGP = state is ExpenseLoaded ? state.totalBalanceEGP : 0.0;

          final totalIncomeUSD = state is ExpenseLoaded ? state.totalIncomeUSD : 0.0;
          final totalIncomeEGP = state is ExpenseLoaded ? state.totalIncomeEGP : 0.0;

          final totalExpensesUSD = state is ExpenseLoaded ? state.totalExpensesUSD : 0.0;
          final totalExpensesEGP = state is ExpenseLoaded ? state.totalExpensesEGP : 0.0;

          return Stack(
            children: [
              Container(
                height: 280.h,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(29, 85, 243, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
              ),

              Column(
                children: [
                  SizedBox(height: 40.h),

                  /// ---------------- HEADER ----------------
                  DashboardHeader(
                    onChanged: _applyFilter,
                    value: filter,
                  ),
                  /// ---------------- BALANCE CARD ----------------
                  ExpenseSummaryCard(
                    totalBalanceUSD: totalBalanceUSD,
                    totalBalanceEGP: totalBalanceEGP,
                    totalIncomeUSD: totalIncomeUSD,
                    totalIncomeEGP: totalIncomeEGP,
                    totalExpensesUSD: totalExpensesUSD,
                    totalExpensesEGP: totalExpensesEGP,
                  ),

                  SizedBox(height: 24.h),

                  /// ---------------- RECENT EXPENSES ----------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Recent Expenses", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: Text("see all", style: TextStyle(fontSize: 14.sp)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// ---------------- EXPENSE LIST ----------------
                  RecentExpensesList(
                    scrollController: _scrollController,
                    expenses: expenses,
                    from: _filterFrom,
                    to: _filterTo,
                    state: state,
                  )
                ],
              ),
            ],
          );
        },
      ),

      /// ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

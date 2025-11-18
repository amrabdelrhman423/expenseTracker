import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../../../core/models/expense.dart';
import '../../../core/constants/categories.dart';
import 'package:intl/intl.dart';

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
    context.read<ExpenseBloc>().add(
      LoadExpenses(from: _filterFrom, to: _filterTo),
    );
  }

  void _applyFilter(String f) {
    setState(() {
      filter = f;
      final now = DateTime.now();

      if (f == 'This Month') {
        _filterFrom = DateTime(now.year, now.month, 1);
        _filterTo = DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(Duration(seconds: 1));
      } else if (f == 'Last 7 Days') {
        _filterFrom = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: 6));
        _filterTo = DateTime(
          now.year,
          now.month,
          now.day + 1,
        ).subtract(Duration(seconds: 1));
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

    if (current >= (max - 200)) {
      final state = context.read<ExpenseBloc>().state;
      if (state is ExpenseLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<ExpenseBloc>().add(LoadMoreExpenses(from: _filterFrom, to: _filterTo),
        );
      }
    }
  }

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

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

  Color _getCategoryColor(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Colors.orange;
      case 'local_cafe':
        return Colors.purple;
      case 'directions_car':
        return Colors.blue;
      case 'home':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF5F5F5),
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
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text("Error: ${state.message}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(
                        LoadExpenses(from: _filterFrom, to: _filterTo),
                      );
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final expenses = state is ExpenseLoaded
              ? state.expenses
              : <Expense>[];

          final totalBalanceUSD = state is ExpenseLoaded
              ? state.totalBalanceUSD
              : 0.0;
          final totalBalanceEGP = state is ExpenseLoaded
              ? state.totalBalanceEGP
              : 0.0;

          final totalIncomeUSD = state is ExpenseLoaded
              ? state.totalIncomeUSD
              : 0.0;
          final totalIncomeEGP = state is ExpenseLoaded
              ? state.totalIncomeEGP
              : 0.0;

          final totalExpensesUSD = state is ExpenseLoaded
              ? state.totalExpensesUSD
              : 0.0;
          final totalExpensesEGP = state is ExpenseLoaded
              ? state.totalExpensesEGP
              : 0.0;

          return Stack(
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(29, 85, 243, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              Column(
                children: [
                  // HEADER
                 const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blue[100],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getGreeting(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Amr",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            value: filter,
                            items: ["This Month", "Last 7 Days", "All"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => _applyFilter(v!),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BALANCE CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(72, 109, 240,1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Balance",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),

                          // USD
                          Text(
                            "\$${totalBalanceUSD.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // EGP
                          Text(
                            "E£${totalBalanceEGP.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // INCOME
                              Expanded(

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Income",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),

                                    // USD
                                    Text(
                                      "\$${totalIncomeUSD.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // EGP
                                    Text(
                                      "E£${totalIncomeEGP.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              // EXPENSES
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Expenses",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),

                                    // USD
                                    Text(
                                      "\$${totalExpensesUSD.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // EGP
                                    Text(
                                      "E£${totalExpensesEGP.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // EXPENSE LIST TITLE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Expenses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(onPressed: () {}, child: Text("see all")),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Expenses List
                  Expanded(
                    child: expenses.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              context.read<ExpenseBloc>().add(
                                RefreshExpenses(
                                  from: _filterFrom,
                                  to: _filterTo,
                                ),
                              );
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No expenses yet',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Tap the + button to add your first expense',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              context.read<ExpenseBloc>().add(
                                RefreshExpenses(
                                  from: _filterFrom,
                                  to: _filterTo,
                                ),
                              );
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              itemCount:
                                  expenses.length +
                                  (state is ExpenseLoaded && state.hasMore
                                      ? 1
                                      : 0),
                              itemBuilder: (context, idx) {
                                if (idx >= expenses.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final expense = expenses[idx];
                                final category =
                                    CategoryConstants.getCategoryById(
                                      expense.categoryId,
                                    );
                                final icon = category != null
                                    ? CategoryConstants.getIconData(
                                        category.iconName,
                                      )
                                    : Icons.category;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.08),
                                        spreadRadius: 0,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(
                                            category?.iconName ?? 'category',
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          icon,
                                          color: _getCategoryColor(
                                            category?.iconName ?? 'category',
                                          ),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category?.title ??
                                                  expense.categoryId,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Manually',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${expense.convertedAmountUSD.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            "E£${expense.amount}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _formatDate(expense.date),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', 0),
                _buildNavItem(Icons.bar_chart, 'Analytics', 1),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                    onPressed: (){
                      Navigator.pushNamed(context, '/addExpense');
                      },
                  elevation: 0,
                  child: _buildNavItem(Icons.add_circle, 'Add', 2, isAdd: true),

                ),
                _buildNavItem(Icons.account_balance_wallet, 'Wallet', 3),
                _buildNavItem(Icons.person, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isAdd = false,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          if (isAdd) {
            Navigator.pushNamed(context, '/addExpense');
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAdd)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          else
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 24),
          if (!isAdd) const SizedBox(height: 4),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

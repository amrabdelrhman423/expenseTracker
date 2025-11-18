import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/dashboard/views/dashboard_screen.dart';
import 'features/add_expense/views/add_expense_screen.dart';
import 'core/injection/injection_container.dart';
import 'features/dashboard/bloc/expense_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (_) => getIt<ExpenseBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home:  DashboardScreen(),
        routes: {
          '/addExpense': (context) =>  AddExpenseScreen(),
        },
      ),
    );
  }
}
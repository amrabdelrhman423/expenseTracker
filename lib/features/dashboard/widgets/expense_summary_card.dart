import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/expense_bloc.dart';


class ExpenseSummaryCard extends StatefulWidget {
   ExpenseSummaryCard({super.key , required this.totalBalanceUSD , required this.totalBalanceEGP , required this.totalIncomeUSD , required this.totalIncomeEGP , required this.totalExpensesUSD , required this.totalExpensesEGP});

   double  totalBalanceUSD ;
  double  totalBalanceEGP ;

  double  totalIncomeUSD ;
  double  totalIncomeEGP ;

  double  totalExpensesUSD ;
  double  totalExpensesEGP ;

  @override
  State<ExpenseSummaryCard> createState() => _ExpenseSummaryCardState();
}

class _ExpenseSummaryCardState extends State<ExpenseSummaryCard> {
   String currency = "USD";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Color.fromRGBO(72, 109, 240, 1),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Balance",
                style: TextStyle(color: Colors.white70, fontSize: 16.sp)),

            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                setState(() => currency = value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: "USD", child: Text("Show USD")),
                PopupMenuItem(value: "EGP", child: Text("Show EGP")),
              ],
            ),
          ],
        ),
            SizedBox(height: 6.h),

            Text(
             currency == "EGP" ? "E£${widget.totalBalanceEGP.toStringAsFixed(2)}" : "\$${widget.totalBalanceUSD.toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),


            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _incomeBox(widget.totalIncomeUSD, widget.totalIncomeEGP),
                SizedBox(width: 20.w),
                _expenseBox(widget.totalExpensesUSD, widget.totalExpensesEGP),
              ],
            ),
          ],
        ),
      ),
    );


  }

  Widget _incomeBox(double usd, double egp) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.white70, size: 18.sp),
            SizedBox(width: 5.w),
            Text("Income", style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
            currency == "EGP"? "E£${egp.toStringAsFixed(2)}" : "\$${usd.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),

      ],
    ),
  );

  Widget _expenseBox(double usd, double egp) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_upward, color: Colors.white70, size: 18.sp),
            SizedBox(width: 5.w),
            Text("Expenses", style: TextStyle(color: Colors.white70, fontSize: 15.sp)),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
            currency == "EGP" ? "E£${egp.toStringAsFixed(2)}" : "\$${usd.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
        // Text("E£${egp.toStringAsFixed(2)}",
        //     style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
      ],
    ),
  );
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1.w,
            blurRadius: 4.w,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.bar_chart, 'Analytics', 1),

              /// FAB
              FloatingActionButton(
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: const CircleBorder(),  // ← يجبره يكون دايرة 100%
                onPressed: () {
                  Navigator.pushNamed(context, '/addExpense');
                },
                child: Icon(Icons.add, size: 28.sp, color: Colors.white),
              ),

              _buildNavItem(Icons.account_balance_wallet, 'Wallet', 3),
              _buildNavItem(Icons.person, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.sp, color: index == 0 ? Colors.blue : Colors.grey),
        ],
      ),
    );
  }
}
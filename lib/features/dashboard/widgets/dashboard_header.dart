
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeader extends StatelessWidget {
   DashboardHeader({super.key , required this.onChanged , required this.value});

  void Function(String) onChanged;
   String? value;

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.person, size: 24.sp, color: Colors.blue),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  Text(
                    "Amr",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// FILTER DROPDOWN
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              underline: SizedBox(),
              value: value,
              items: ["This Month", "Last 7 Days", "All"]
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(fontSize: 14.sp)),
                ),
              )
                  .toList(),
              onChanged: (v) => {
                onChanged(v!)
              },
            ),
          ),
        ],
      ),
    );
  }
}

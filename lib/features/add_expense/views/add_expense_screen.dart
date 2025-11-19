import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dashboard/bloc/expense_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/categories.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _categoryId = 'entertainment';
  final _amountController = TextEditingController();
  final String _currency = 'EGP';
  DateTime _date = DateTime.now();
  String? _receiptPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    if (result != null) {
      final x = await _picker.pickImage(source: result);
      if (x != null) setState(() => _receiptPath = x.path);
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _date = d);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be > 0')),
      );
      return;
    }

    context.read<ExpenseBloc>().add(AddExpenseEvent(
      categoryId: _categoryId!,
      amount: amount,
      currency: _currency,
      date: _date,
      receiptPath: _receiptPath,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Expense',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.w),
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              elevation: 0,
            ),
            child: Text('Save', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            _buildLabel('Categories'),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: InputDecoration(border: InputBorder.none, isDense: true),
                items: CategoryConstants.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(CategoryConstants.getIconData(category.iconName),
                            size: 20.sp, color: Colors.grey[700]),
                        SizedBox(width: 12.w),
                        Text(category.title, style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel('Amount'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'E£50,000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.blue, width: 2)),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
            ),
            SizedBox(height: 24.h),
            _buildLabel('Date'),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MM/dd/yy').format(_date), style: TextStyle(fontSize: 16.sp)),
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel('Attach Receipt'),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _pickReceipt,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _receiptPath == null ? 'Upload image' : 'Image selected',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _receiptPath == null ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                    Icon(Icons.camera_alt, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text('Categories', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemCount: CategoryConstants.categories.length,
              itemBuilder: (context, index) {
                final category = CategoryConstants.categories[index];
                final isSelected = _categoryId == category.id;
                final color = _getCategoryColor(category.iconName).withOpacity(isSelected ? 1.0 : 0.5);
                return GestureDetector(
                  onTap: () => setState(() => _categoryId = category.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        child: Icon(
                          CategoryConstants.getIconData(category.iconName),
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? color : Colors.black.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[700]),
    );
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
      case 'entertainment':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

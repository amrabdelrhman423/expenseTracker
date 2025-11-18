import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/bloc/expense_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/categories.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _categoryId = 'entertainment';
  final _amountController = TextEditingController();
  String _currency = 'EGP';
  DateTime _date = DateTime.now();
  String? _receiptPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _receiptPath = x.path);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Amount must be > 0')),);
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
    final selectedCategory = CategoryConstants.getCategoryById(_categoryId ?? '');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child:  const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Categories Dropdown
            _buildLabel('Categories'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                items: CategoryConstants.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(CategoryConstants.getIconData(category.iconName),
                            size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 12),
                        Text(category.title),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            ),

            const SizedBox(height: 24),

            // Amount Field
            _buildLabel('Amount'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '\$50,000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
            ),

            const SizedBox(height: 24),

            // Date Field
            _buildLabel('Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MM/dd/yy').format(_date),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Attach Receipt Field
            _buildLabel('Attach Receipt'),

            const SizedBox(height: 8),
            InkWell(
              onTap: _pickReceipt,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _receiptPath == null ? 'Upload image' : 'Image selected',
                      style: TextStyle(
                        fontSize: 16,
                        color: _receiptPath == null ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                    Icon(Icons.camera_alt, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Categories Grid
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: CategoryConstants.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == CategoryConstants.categories.length) {
                  // Add Category button
                  return GestureDetector(
                    onTap: () {
                      // TODO: Implement add category
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.blue[700], size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add Category',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final category = CategoryConstants.categories[index];
                final isSelected = _categoryId == category.id;

                return GestureDetector(
                  onTap: () => setState(() => _categoryId = category.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[700] : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CategoryConstants.getIconData(category.iconName),
                          color: isSelected ? Colors.white : Colors.grey[700],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.blue[700] : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),


            // Save Button
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }
}

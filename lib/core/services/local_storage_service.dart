import 'package:hive/hive.dart';
import '../models/expense.dart';

class LocalStorageService {
  static const String expenseBox = 'expenses';

  Future<void> init(String path) async {
    // Hive.initFlutter() and Hive.openBox are already called in main.dart
    // This method is kept for consistency but doesn't need to do anything
    // The box is already open and ready to use
  }

  Box<Expense> _expenseBox() => Hive.box<Expense>(expenseBox);

  Future<void> addExpense(Expense e) async {
    await _expenseBox().put(e.id, e);
  }

  Future<List<Expense>> getExpenses({int page = 0, int pageSize = 10, DateTime? from, DateTime? to}) async {
    final all = _expenseBox().values.toList()
      ..sort((a,b) => b.date.compareTo(a.date)); // newest first
    final filtered = (from != null && to != null)
        ? all.where((x) {
            // Include expenses on or after 'from' and on or before 'to'
            final expenseDate = DateTime(x.date.year, x.date.month, x.date.day);
            final fromDate = DateTime(from.year, from.month, from.day);
            final toDate = DateTime(to.year, to.month, to.day);
            return (expenseDate.isAfter(fromDate) || expenseDate.isAtSameMomentAs(fromDate)) &&
                   (expenseDate.isBefore(toDate) || expenseDate.isAtSameMomentAs(toDate));
          }).toList()
        : all;
    final start = page * pageSize;
    if (start >= filtered.length) return [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  Future<int> totalCount({DateTime? from, DateTime? to}) async {

    final all = _expenseBox().values.toList();
    final filtered = (from != null && to != null)
        ? all.where((x) {
            // Include expenses on or after 'from' and on or before 'to'
            final expenseDate = DateTime(x.date.year, x.date.month, x.date.day);
            final fromDate = DateTime(from.year, from.month, from.day);
            final toDate = DateTime(to.year, to.month, to.day);
            return (expenseDate.isAfter(fromDate) || expenseDate.isAtSameMomentAs(fromDate)) &&
                   (expenseDate.isBefore(toDate) || expenseDate.isAtSameMomentAs(toDate));
          }).toList()
        : all;
    return filtered.length;
  }

  // Get all expenses for summary calculation (not paginated)
  Future<List<Expense>> getAllExpenses({DateTime? from, DateTime? to}) async {
    final all = _expenseBox().values.toList();
    final filtered = (from != null && to != null)
        ? all.where((x) {
            final expenseDate = DateTime(x.date.year, x.date.month, x.date.day);
            final fromDate = DateTime(from.year, from.month, from.day);
            final toDate = DateTime(to.year, to.month, to.day);
            return (expenseDate.isAfter(fromDate) || expenseDate.isAtSameMomentAs(fromDate)) &&
                   (expenseDate.isBefore(toDate) || expenseDate.isAtSameMomentAs(toDate));
          }).toList()
        : all;
    return filtered;
  }
}

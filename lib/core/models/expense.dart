import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double amount; // selected currency amount

  @HiveField(3)
  final String currency; // EGP / USD / EUR

  @HiveField(4)
  final double convertedAmountUSD;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? receiptPath;

  @HiveField(7)
  final double amountEGP; // ⭐ NEW FIELD

  Expense({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.currency,
    required this.convertedAmountUSD,
    required this.date,
    this.receiptPath,
    required this.amountEGP, // ⭐ ADD HERE
  });
}

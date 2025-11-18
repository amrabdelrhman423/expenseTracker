import 'package:hive/hive.dart';

part 'expense.g.dart'; // run build_runner to generate

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id; // uuid

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final double amount; // original amount in selected currency

  @HiveField(3)
  final String currency; // e.g., "EGP"

  @HiveField(4)
  final double convertedAmountUSD; // converted to USD at save time

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? receiptPath; // local path

  Expense({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.currency,
    required this.convertedAmountUSD,
    required this.date,
    this.receiptPath,
  });
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/models/expense.dart';
import 'core/injection/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());

  // Setup dependency injection (this will open the Hive box)
  await di.setupDependencies();

  runApp(const MyApp());
}

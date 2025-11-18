import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/exchange_api.dart';
import '../services/local_storage_service.dart';
import '../repositories/expense_repository.dart';
import '../../features/dashboard/bloc/expense_bloc.dart';
import '../models/expense.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Get application documents directory for Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  
  // Open Hive box (Hive.initFlutter() and adapter registration are done in main.dart)
  await Hive.openBox<Expense>(LocalStorageService.expenseBox);
  
  // Services
  getIt.registerLazySingleton<ExchangeApi>(
    () => ExchangeApi(),
  );

  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(),
  );

  // Initialize LocalStorageService
  final localStorageService = getIt<LocalStorageService>();
  await localStorageService.init(appDocumentDir.path);

  // Repositories
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepository(
      local: getIt<LocalStorageService>(),
      api: getIt<ExchangeApi>(),
    ),
  );

  // BLoCs - Factory because we might want multiple instances or recreate them
  getIt.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(
      repo: getIt<ExpenseRepository>(),
    ),
  );
}


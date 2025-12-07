import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar todas las dependencias
import 'data/data_sources/local_expense_data_source.dart';
import 'data/repositories/expense_repository_impl.dart';
import 'domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'domain/usecases/expense_usecases/get_expenses_usecase.dart';
import 'domain/usecases/expense_usecases/update_expense_usecase.dart';
import 'domain/usecases/expense_usecases/delete_expense_usecase.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/screens/expense_list_screen.dart'; // Creamos esta pantalla en el Paso 

void main() {
  // 1. Inicializar Data Source (La capa más interna)
  final localDataSource = LocalExpenseDataSource();
  
  // 2. Inicializar Repositorio (Implementación)
  final expenseRepository = ExpenseRepositoryImpl(localDataSource: localDataSource);

  // 3. Inicializar Casos de Uso (Dependen del Repositorio)
  final addExpenseUseCase = AddExpenseUseCase(expenseRepository);
  final getExpensesUseCase = GetExpensesUseCase(expenseRepository);
  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepository);
  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository);

  // 4. Inicializar la Aplicación con el Provider inyectado
  runApp(MyApp(
    addExpenseUseCase: addExpenseUseCase,
    getExpensesUseCase: getExpensesUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  const MyApp({
    super.key,
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 5. Proporcionar el ExpenseProvider (Depende de los Casos de Uso)
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(
            addExpenseUseCase: addExpenseUseCase,
            getExpensesUseCase: getExpensesUseCase,
            updateExpenseUseCase: updateExpenseUseCase,
            deleteExpenseUseCase: deleteExpenseUseCase,
          )..loadExpenses(), // Llama a loadExpenses al iniciar
        ),
      ],
      child: MaterialApp(
        title: 'Registro y control de Gastos',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const ExpenseListScreen(), // Pantalla principal
      ),
    );
  }
}
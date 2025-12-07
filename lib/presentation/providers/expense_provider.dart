import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Necesitas esta dependencia para generar IDs
import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/update_expense_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/delete_expense_usecase.dart';

// Necesitas agregar 'uuid' a tu pubspec.yaml:
// dependencies:
//   uuid: ^4.3.3 (o la versión actual)

class ExpenseProvider with ChangeNotifier {
  // 1. Dependencias (Casos de Uso)
  final AddExpenseUseCase addExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  // 2. Estado Interno
  List<Expense> _expenses = [];
  bool _isLoading = false;
  
  // Usaremos 'uuid' para generar IDs únicos
  final _uuid = const Uuid();

  // Constructor que recibe todos los casos de uso
  ExpenseProvider({
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  // 3. Getters para la UI
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  double get totalBalance {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // 4. Métodos CRUD para la UI

  // Iniciar la carga de datos al abrir la app
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _expenses = await getExpensesUseCase(null); // 'null' porque no necesita parámetros
    } catch (e) {
      // Manejo de errores simple
      print('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense({
    required String description,
    required double amount,
    required DateTime date,
    required String category,
  }) async {
    // Generar un ID único antes de crear la entidad
    final newExpense = Expense(
      id: _uuid.v4(), 
      description: description,
      amount: amount,
      date: date,
      category: category,
    );

    await addExpenseUseCase(newExpense);
    
    // Actualizar el estado local y notificar a la UI
    _expenses.add(newExpense);
    notifyListeners();
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    await updateExpenseUseCase(updatedExpense);
    
    // Actualizar el estado local (encontrar y reemplazar)
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    await deleteExpenseUseCase(id);

    // Actualizar el estado local
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }
}
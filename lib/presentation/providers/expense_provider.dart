/*
 * Archivo: expense_provider.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es el GESTOR DE ESTADO que actúa como adaptador entre la UI y los casos de uso.
 * Utiliza el patrón Provider de Flutter para manejar el estado de la aplicación y
 * notificar cambios a la interfaz. Esta clase pertenece a la capa de presentación
 * y coordina las interacciones del usuario con la lógica de negocio.
 * 
 * Cómo interactúa con otros archivos:
 * - Depende de todos los CASOS DE USO de expenses (inyectados)
 * - Mantiene una lista de objetos Expense como estado
 * - Es consumido por ExpenseListScreen y AddExpenseScreen mediante Provider
 * - Utiliza la librería uuid para generar IDs únicos
 * - Notifica cambios a la UI mediante ChangeNotifier
 * 
 * Descripción del código:
 * La clase ExpenseProvider extiende ChangeNotifier para implementar el patrón Observer
 * y gestionar el estado reactivo de la aplicación. Recibe los cuatro casos de uso como
 * dependencias en su constructor (inyección de dependencias). Mantiene estado interno
 * con _expenses (lista de gastos), _isLoading (indicador de carga), y usa Uuid para
 * generar identificadores únicos. Proporciona getters públicos para acceder al estado.
 * Los métodos CRUD ejecutan el caso de uso correspondiente, actualizan el estado local,
 * y llaman a notifyListeners() para que la UI se reconstruya automáticamente.
 */

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/add_expense_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/get_expenses_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/update_expense_usecase.dart';
import 'package:expense_tracker_session/domain/usecases/expense_usecases/delete_expense_usecase.dart';

/// Gestor de Estado para los gastos usando el patrón Provider
/// 
/// Esta clase coordina las interacciones entre la UI y la lógica de negocio.
class ExpenseProvider with ChangeNotifier {
  // === DEPENDENCIAS (Casos de Uso) ===
  
  /// Caso de uso para agregar gastos
  final AddExpenseUseCase addExpenseUseCase;
  
  /// Caso de uso para obtener la lista de gastos
  final GetExpensesUseCase getExpensesUseCase;
  
  /// Caso de uso para actualizar gastos
  final UpdateExpenseUseCase updateExpenseUseCase;
  
  /// Caso de uso para eliminar gastos
  final DeleteExpenseUseCase deleteExpenseUseCase;

  // === ESTADO INTERNO ===
  
  /// Lista privada de gastos (estado de la aplicación)
  List<Expense> _expenses = [];
  
  /// Indicador de si se están cargando los datos
  bool _isLoading = false;
  
  /// Generador de IDs únicos usando UUID v4
  final _uuid = const Uuid();

  /// Constructor que recibe todos los casos de uso mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [addExpenseUseCase]: Caso de uso para agregar gastos
  /// - [getExpensesUseCase]: Caso de uso para obtener gastos
  /// - [updateExpenseUseCase]: Caso de uso para actualizar gastos
  /// - [deleteExpenseUseCase]: Caso de uso para eliminar gastos
  ExpenseProvider({
    required this.addExpenseUseCase,
    required this.getExpensesUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  // === GETTERS PÚBLICOS PARA LA UI ===
  
  /// Obtiene la lista de gastos (acceso de solo lectura)
  List<Expense> get expenses => _expenses;
  
  /// Indica si los datos se están cargando actualmente
  bool get isLoading => _isLoading;

  /// Calcula el balance total sumando todos los montos de los gastos
  /// 
  /// Usa fold para iterar sobre todos los gastos y sumar sus montos.
  /// 
  /// Retorna: El total de todos los gastos como double
  double get totalBalance {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // === MÉTODOS CRUD PARA LA UI ===

  /// Carga todos los gastos desde el caso de uso al iniciar la aplicación
  /// 
  /// Este método debe ser llamado al inicializar el provider (generalmente en main.dart).
  /// Establece _isLoading en true mientras carga, ejecuta el caso de uso, y actualiza
  /// el estado local con los gastos obtenidos.
  /// 
  /// Retorna: Future<void> que completa cuando los gastos han sido cargados
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners(); // Notifica a la UI para mostrar indicador de carga
    try {
      // Ejecuta el caso de uso para obtener todos los gastos
      _expenses = await getExpensesUseCase(null);
    } catch (e) {
      // Manejo básico de errores (en producción se usaría un sistema más robusto)
      print('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a la UI que la carga ha terminado
    }
  }

  /// Añade un nuevo gasto al sistema
  /// 
  /// Este método genera un ID único, crea el objeto Expense, ejecuta el caso de uso
  /// para agregarlo, actualiza el estado local, y notifica a la UI.
  /// 
  /// Parámetros:
  /// - [description]: Descripción del gasto
  /// - [amount]: Monto del gasto (debe ser positivo)
  /// - [date]: Fecha en que ocurrió el gasto
  /// - [category]: Categoría del gasto
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido agregado
  Future<void> addExpense({
    required String description,
    required double amount,
    required DateTime date,
    required String category,
  }) async {
    // Genera un ID único usando UUID v4
    final newExpense = Expense(
      id: _uuid.v4(), 
      description: description,
      amount: amount,
      date: date,
      category: category,
    );

    // Ejecuta el caso de uso para agregar el gasto
    await addExpenseUseCase(newExpense);
    
    // Actualiza el estado local y notifica a la UI
    _expenses.add(newExpense);
    notifyListeners();
  }

  /// Actualiza un gasto existente
  /// 
  /// Este método recibe un objeto Expense con los datos actualizados, ejecuta el
  /// caso de uso correspondiente, busca y reemplaza el gasto en el estado local,
  /// y notifica a la UI.
  /// 
  /// Parámetros:
  /// - [updatedExpense]: El objeto Expense con los datos actualizados
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido actualizado
  Future<void> updateExpense(Expense updatedExpense) async {
    // Ejecuta el caso de uso para actualizar el gasto
    await updateExpenseUseCase(updatedExpense);
    
    // Busca el índice del gasto en el estado local
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      // Reemplaza el gasto antiguo con el actualizado
      _expenses[index] = updatedExpense;
      notifyListeners(); // Notifica a la UI del cambio
    }
  }

  /// Elimina un gasto del sistema
  /// 
  /// Este método ejecuta el caso de uso para eliminar, remueve el gasto del estado
  /// local, y notifica a la UI.
  /// 
  /// Parámetros:
  /// - [id]: El identificador único del gasto a eliminar
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido eliminado
  Future<void> deleteExpense(String id) async {
    // Ejecuta el caso de uso para eliminar el gasto
    await deleteExpenseUseCase(id);

    // Remueve el gasto del estado local
    _expenses.removeWhere((expense) => expense.id == id);
    
    // Notifica a la UI del cambio
    notifyListeners();
  }
}
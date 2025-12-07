import 'package:expense_tracker_session/domain/entities/expense.dart';

/// Interfaz para el Data Source. Define el contrato para el manejo de datos.
abstract class ExpenseDataSource {
  Future<void> add(Expense expense);
  Future<List<Expense>> getAll();
  Future<void> update(Expense expense);
  Future<void> delete(String id);
}

/// Implementación del Data Source en memoria (sin persistencia).
class LocalExpenseDataSource implements ExpenseDataSource {
  // Lista que actúa como nuestro "almacenamiento" temporal en memoria.
  final List<Expense> _expenses = [];

  // Implementación de los métodos CRUD

  @override
  Future<void> add(Expense expense) async {
    // En un caso real, aquí se generaría el ID, pero en nuestro caso de uso
    // simple, asumimos que el ID se genera antes de llamar a este método.
    _expenses.add(expense);
  }

  @override
  Future<void> delete(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
  }

  @override
  Future<List<Expense>> getAll() async {
    // Retorna una copia de la lista para evitar modificaciones externas directas
    // (aunque en este contexto simple es opcional, es buena práctica).
    return List.from(_expenses);
  }

  @override
  Future<void> update(Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
    } 
    // Opcional: Podrías lanzar una excepción si el gasto no existe.
  }
}
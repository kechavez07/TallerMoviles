import '../entities/expense.dart';

/// Contrato (Interfaz) que define las operaciones CRUD para la entidad Expense.
/// La capa de Dominio depende de esta interfaz, no de su implementación.
abstract class ExpenseRepository {
  
  // Create
  Future<void> addExpense(Expense expense);

  // Read (All)
  Future<List<Expense>> getExpenses();

  // Update
  Future<void> updateExpense(Expense expense);

  // Delete
  Future<void> deleteExpense(String id);
}
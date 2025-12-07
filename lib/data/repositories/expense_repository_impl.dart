import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/data/data_sources/local_expense_data_source.dart';

/// Implementación del contrato ExpenseRepository.
/// Conecta la capa de Dominio (Repository Contract) con la capa de Datos (Data Source).
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addExpense(Expense expense) {
    // El Repositorio simplemente delega la llamada al Data Source.
    return localDataSource.add(expense);
  }

  @override
  Future<void> deleteExpense(String id) {
    return localDataSource.delete(id);
  }

  @override
  Future<List<Expense>> getExpenses() {
    return localDataSource.getAll();
  }

  @override
  Future<void> updateExpense(Expense expense) {
    return localDataSource.update(expense);
  }
}
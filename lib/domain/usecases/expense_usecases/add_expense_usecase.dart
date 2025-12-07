import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

// Este caso de uso no necesita parámetros, ya que la entidad Expense es el parámetro.
class AddExpenseUseCase implements VoidUseCase<Expense> {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  @override
  Future<void> call(Expense expense) async {
    // Aquí se podría poner lógica de negocio específica para "añadir", 
    // como validación o transformación antes de llamar al repositorio.
    // En nuestro caso, simplemente delegamos.
    await repository.addExpense(expense);
  }
}
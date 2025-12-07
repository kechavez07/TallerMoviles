import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

// Usaremos 'void' como parámetro (P) ya que no necesitamos entradas.
class GetExpensesUseCase implements UseCase<List<Expense>, void> {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  @override
  Future<List<Expense>> call(void params) async {
    return await repository.getExpenses();
  }
}
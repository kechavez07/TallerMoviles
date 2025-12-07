import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

// El parámetro (P) es el ID del gasto a eliminar (String).
class DeleteExpenseUseCase implements VoidUseCase<String> {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteExpense(id);
  }
}
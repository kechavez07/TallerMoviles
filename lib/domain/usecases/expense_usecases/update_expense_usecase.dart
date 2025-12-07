import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

class UpdateExpenseUseCase implements VoidUseCase<Expense> {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  @override
  Future<void> call(Expense expense) async {
    await repository.updateExpense(expense);
  }
}
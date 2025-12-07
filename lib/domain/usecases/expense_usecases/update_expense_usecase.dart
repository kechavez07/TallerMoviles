/*
 * Archivo: update_expense_usecase.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Implementa el CASO DE USO para actualizar un gasto existente.
 * Encapsula la lógica de negocio asociada con la modificación de gastos.
 * 
 * Cómo interactúa con otros archivos:
 * - Implementa VoidUseCase<Expense>
 * - Depende de ExpenseRepository
 * - Recibe un objeto Expense modificado
 * - Es inyectado y utilizado por ExpenseProvider
 * 
 * Descripción del código:
 * La clase UpdateExpenseUseCase implementa VoidUseCase con Expense como parámetro,
 * recibiendo un objeto de gasto con los datos actualizados. El método call delega
 * la operación al repositorio. En una implementación más compleja, aquí se podrían
 * agregar validaciones como verificar que el gasto exista antes de actualizarlo,
 * validar que los cambios sean coherentes con las reglas de negocio, o registrar
 * auditoría de cambios.
 */

import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

/// Caso de Uso: Actualizar un gasto existente
/// 
/// Este caso de uso recibe un objeto Expense con los datos actualizados.
class UpdateExpenseUseCase implements VoidUseCase<Expense> {
  /// Referencia al repositorio de gastos (contrato, no implementación concreta)
  final ExpenseRepository repository;

  /// Constructor que recibe el repositorio mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [repository]: Implementación del contrato ExpenseRepository
  UpdateExpenseUseCase(this.repository);

  /// Ejecuta el caso de uso para actualizar un gasto existente
  /// 
  /// Este método es llamado automáticamente cuando se invoca el caso de uso.
  /// El gasto se identifica por su ID y se actualiza con los nuevos valores.
  /// 
  /// Parámetros:
  /// - [expense]: El objeto Expense con los datos actualizados
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido actualizado
  /// 
  /// Nota: Aquí se podría agregar lógica adicional como:
  /// - Verificar que el gasto exista antes de actualizarlo
  /// - Validar que los cambios sean coherentes con las reglas de negocio
  /// - Registrar un log de auditoría de los cambios realizados
  @override
  Future<void> call(Expense expense) async {
    await repository.updateExpense(expense);
  }
}
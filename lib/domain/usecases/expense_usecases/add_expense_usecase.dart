/*
 * Archivo: add_expense_usecase.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Implementa el CASO DE USO ESPECÍFICO para agregar un nuevo gasto al sistema.
 * Encapsula la lógica de negocio relacionada con la creación de gastos.
 * 
 * Cómo interactúa con otros archivos:
 * - Implementa VoidUseCase<Expense> (hereda la estructura base)
 * - Depende de ExpenseRepository (el contrato, no la implementación)
 * - Recibe un objeto Expense como parámetro
 * - Es inyectado y utilizado por ExpenseProvider
 * 
 * Descripción del código:
 * La clase AddExpenseUseCase implementa la interfaz VoidUseCase con Expense como tipo
 * de parámetro, lo que significa que recibe un gasto y no retorna nada (solo una
 * confirmación de ejecución exitosa vía Future<void>). Mantiene una referencia al
 * repositorio inyectado en el constructor. El método call acepta un objeto Expense
 * y delega la operación al repositorio. Aunque en la implementación actual solo delega,
 * este patrón permite agregar validaciones de negocio adicionales antes de persistir
 * los datos.
 */

import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

/// Caso de Uso: Agregar un nuevo gasto al sistema
/// 
/// Este caso de uso recibe un objeto Expense completo como parámetro.
class AddExpenseUseCase implements VoidUseCase<Expense> {
  /// Referencia al repositorio de gastos (contrato, no implementación concreta)
  final ExpenseRepository repository;

  /// Constructor que recibe el repositorio mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [repository]: Implementación del contrato ExpenseRepository
  AddExpenseUseCase(this.repository);

  /// Ejecuta el caso de uso para agregar un gasto
  /// 
  /// Este método es llamado automáticamente cuando se invoca el caso de uso
  /// como una función gracias al método call.
  /// 
  /// Parámetros:
  /// - [expense]: El objeto Expense que se desea agregar al sistema
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido agregado
  /// 
  /// Nota: Aquí se podría agregar lógica de validación adicional como:
  /// - Verificar que el monto sea positivo
  /// - Validar que la descripción no esté vacía
  /// - Aplicar reglas de negocio específicas del dominio
  @override
  Future<void> call(Expense expense) async {
    // Delega la operación al repositorio
    await repository.addExpense(expense);
  }
}
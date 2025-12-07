/*
 * Archivo: get_expenses_usecase.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Implementa el CASO DE USO para recuperar todos los gastos del sistema.
 * Encapsula la lógica de obtención y posiblemente filtrado o transformación de gastos.
 * 
 * Cómo interactúa con otros archivos:
 * - Implementa UseCase<List<Expense>, void> (retorna lista, no necesita parámetros)
 * - Depende de ExpenseRepository
 * - Retorna una lista de objetos Expense
 * - Es inyectado y utilizado por ExpenseProvider para cargar los datos
 * 
 * Descripción del código:
 * La clase GetExpensesUseCase implementa UseCase con List<Expense> como tipo de retorno
 * y void como tipo de parámetro, indicando que obtiene una lista de gastos sin necesitar
 * parámetros de entrada. El método call acepta un parámetro void (ignorado) y retorna
 * el resultado de llamar a repository.getExpenses(). Esta capa de indirección permite
 * en el futuro agregar lógica como ordenamiento por defecto, filtrado de gastos según
 * reglas de negocio, o transformaciones de datos.
 */

import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

/// Caso de Uso: Obtener todos los gastos del sistema
/// 
/// Este caso de uso no requiere parámetros de entrada (void).
class GetExpensesUseCase implements UseCase<List<Expense>, void> {
  /// Referencia al repositorio de gastos (contrato, no implementación concreta)
  final ExpenseRepository repository;

  /// Constructor que recibe el repositorio mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [repository]: Implementación del contrato ExpenseRepository
  GetExpensesUseCase(this.repository);

  /// Ejecuta el caso de uso para obtener todos los gastos
  /// 
  /// Este método es llamado automáticamente cuando se invoca el caso de uso.
  /// 
  /// Parámetros:
  /// - [params]: void (no se requieren parámetros)
  /// 
  /// Retorna: Future<List<Expense>> con la lista completa de gastos
  /// 
  /// Nota: Aquí se podría agregar lógica adicional como:
  /// - Ordenamiento por fecha o monto
  /// - Filtrado según reglas de negocio
  /// - Cálculos o transformaciones de datos
  @override
  Future<List<Expense>> call(void params) async {
    return await repository.getExpenses();
  }
}
/*
 * Archivo: delete_expense_usecase.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Implementa el CASO DE USO para eliminar un gasto del sistema por su identificador.
 * Encapsula la lógica de negocio relacionada con la eliminación de gastos.
 * 
 * Cómo interactúa con otros archivos:
 * - Implementa VoidUseCase<String> (recibe el ID como string)
 * - Depende de ExpenseRepository
 * - Es inyectado y utilizado por ExpenseProvider
 * 
 * Descripción del código:
 * La clase DeleteExpenseUseCase implementa VoidUseCase con String como tipo de parámetro,
 * ya que solo necesita el identificador del gasto a eliminar. El método call recibe el ID
 * y llama al método correspondiente del repositorio. Aunque actualmente solo delega, este
 * caso de uso podría ampliarse para incluir validaciones como verificar permisos de
 * eliminación, realizar eliminaciones lógicas en lugar de físicas, o ejecutar limpieza
 * de datos relacionados antes de eliminar el gasto.
 */

import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/domain/usecases/usecase.dart';

/// Caso de Uso: Eliminar un gasto del sistema
/// 
/// Este caso de uso recibe el ID del gasto a eliminar como parámetro (String).
class DeleteExpenseUseCase implements VoidUseCase<String> {
  /// Referencia al repositorio de gastos (contrato, no implementación concreta)
  final ExpenseRepository repository;

  /// Constructor que recibe el repositorio mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [repository]: Implementación del contrato ExpenseRepository
  DeleteExpenseUseCase(this.repository);

  /// Ejecuta el caso de uso para eliminar un gasto
  /// 
  /// Este método es llamado automáticamente cuando se invoca el caso de uso.
  /// 
  /// Parámetros:
  /// - [id]: El identificador único del gasto a eliminar
  /// 
  /// Retorna: Future<void> que completa cuando el gasto ha sido eliminado
  /// 
  /// Nota: Aquí se podría agregar lógica adicional como:
  /// - Verificar permisos de eliminación
  /// - Implementar eliminación lógica en lugar de física
  /// - Ejecutar limpieza de datos relacionados
  /// - Registrar auditoría de la eliminación
  @override
  Future<void> call(String id) async {
    await repository.deleteExpense(id);
  }
}
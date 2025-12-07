/*
 * Archivo: expense_repository_impl.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es la IMPLEMENTACIÓN CONCRETA DEL REPOSITORIO que cumple con el contrato definido
 * en la capa de dominio. Actúa como intermediario entre los casos de uso y las fuentes
 * de datos, traduciendo las operaciones del dominio a operaciones del data source.
 * 
 * Cómo interactúa con otros archivos:
 * - Implementa el contrato ExpenseRepository del dominio
 * - Depende de ExpenseDataSource (la interfaz)
 * - Recibe LocalExpenseDataSource mediante inyección de dependencias
 * - Trabaja con entidades Expense
 * - Es instanciado en main.dart y usado por todos los casos de uso
 * 
 * Descripción del código:
 * La clase ExpenseRepositoryImpl implementa la interfaz ExpenseRepository declarada
 * en la capa de dominio. Recibe un ExpenseDataSource a través de su constructor
 * (inyección de dependencias), lo que permite desacoplar la implementación concreta
 * de la fuente de datos. Cada método del repositorio (addExpense, deleteExpense,
 * getExpenses, updateExpense) simplemente delega la llamada al data source correspondiente.
 * Aunque en este caso la delegación es directa, en implementaciones más complejas el
 * repositorio podría combinar múltiples fuentes de datos, transformar modelos, o
 * implementar estrategias de caché.
 */

import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/domain/repositories/expense_repository.dart';
import 'package:expense_tracker_session/data/data_sources/local_expense_data_source.dart';

/// Implementación del contrato ExpenseRepository.
/// Conecta la capa de Dominio (Repository Contract) con la capa de Datos (Data Source).
class ExpenseRepositoryImpl implements ExpenseRepository {
  /// Referencia al Data Source (interfaz, no implementación concreta)
  /// Esto permite cambiar la implementación sin afectar el repositorio.
  final ExpenseDataSource localDataSource;

  /// Constructor que recibe el data source mediante inyección de dependencias
  /// 
  /// Parámetros:
  /// - [localDataSource]: Implementación concreta del ExpenseDataSource
  ExpenseRepositoryImpl({required this.localDataSource});

  /// Implementación del método addExpense del contrato
  /// 
  /// Delega la operación de agregar al data source.
  /// 
  /// Parámetros:
  /// - [expense]: El gasto a agregar
  /// 
  /// Retorna: Future<void> que completa cuando se agrega el gasto
  @override
  Future<void> addExpense(Expense expense) {
    return localDataSource.add(expense);
  }

  /// Implementación del método deleteExpense del contrato
  /// 
  /// Delega la operación de eliminar al data source.
  /// 
  /// Parámetros:
  /// - [id]: El ID del gasto a eliminar
  /// 
  /// Retorna: Future<void> que completa cuando se elimina el gasto
  @override
  Future<void> deleteExpense(String id) {
    return localDataSource.delete(id);
  }

  /// Implementación del método getExpenses del contrato
  /// 
  /// Delega la operación de obtener todos los gastos al data source.
  /// 
  /// Retorna: Future<List<Expense>> con todos los gastos
  @override
  Future<List<Expense>> getExpenses() {
    return localDataSource.getAll();
  }

  /// Implementación del método updateExpense del contrato
  /// 
  /// Delega la operación de actualizar al data source.
  /// 
  /// Parámetros:
  /// - [expense]: El gasto con los datos actualizados
  /// 
  /// Retorna: Future<void> que completa cuando se actualiza el gasto
  @override
  Future<void> updateExpense(Expense expense) {
    return localDataSource.update(expense);
  }
}
/*
 * Archivo: expense_repository.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Este archivo define el CONTRATO DEL REPOSITORIO (interfaz abstracta).
 * En Clean Architecture, el dominio define contratos que las capas externas deben cumplir
 * mediante el Principio de Inversión de Dependencias. Esta interfaz declara las operaciones
 * CRUD necesarias sin especificar cómo se implementan.
 * 
 * Cómo interactúa con otros archivos:
 * - Es implementada por ExpenseRepositoryImpl en la capa de datos
 * - Es utilizada por todos los CASOS DE USO como dependencia
 * - Define las operaciones que trabajan con la entidad Expense
 * - No conoce ni depende de ninguna implementación concreta
 * 
 * Descripción del código:
 * La clase abstracta ExpenseRepository define cuatro métodos asíncronos que representan
 * las operaciones CRUD básicas: addExpense para crear nuevos gastos, getExpenses para
 * recuperar la lista completa de gastos, updateExpense para modificar gastos existentes,
 * y deleteExpense para eliminar gastos por su ID. Todos los métodos retornan Future
 * porque se asume que las operaciones de datos son asincrónicas. Esta abstracción permite
 * que la lógica de negocio (casos de uso) dependa de un contrato estable en lugar de
 * implementaciones concretas que pueden cambiar.
 */

import '../entities/expense.dart';

/// Contrato (Interfaz) que define las operaciones CRUD para la entidad Expense.
/// La capa de Dominio depende de esta interfaz, no de su implementación.
abstract class ExpenseRepository {
  
  /// Método addExpense - Agrega un nuevo gasto al sistema
  /// 
  /// Este método representa la operación CREATE del patrón CRUD.
  /// 
  /// Parámetros:
  /// - [expense]: El objeto Expense que se desea agregar
  /// 
  /// Retorna: Future<void> que completa cuando la operación termina
  Future<void> addExpense(Expense expense);

  /// Método getExpenses - Recupera todos los gastos almacenados
  /// 
  /// Este método representa la operación READ del patrón CRUD.
  /// 
  /// Retorna: Future<List<Expense>> con la lista completa de gastos
  Future<List<Expense>> getExpenses();

  /// Método updateExpense - Actualiza un gasto existente
  /// 
  /// Este método representa la operación UPDATE del patrón CRUD.
  /// El gasto se identifica por su ID contenido en el objeto expense.
  /// 
  /// Parámetros:
  /// - [expense]: El objeto Expense con los datos actualizados
  /// 
  /// Retorna: Future<void> que completa cuando la operación termina
  Future<void> updateExpense(Expense expense);

  /// Método deleteExpense - Elimina un gasto del sistema
  /// 
  /// Este método representa la operación DELETE del patrón CRUD.
  /// 
  /// Parámetros:
  /// - [id]: El identificador único del gasto a eliminar
  /// 
  /// Retorna: Future<void> que completa cuando la operación termina
  Future<void> deleteExpense(String id);
}
/*
 * Archivo: local_expense_data_source.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Define tanto la INTERFAZ DEL DATA SOURCE como su IMPLEMENTACIÓN CONCRETA.
 * Los Data Sources son responsables de acceder a fuentes de datos específicas
 * (base de datos, API, memoria). Esta capa contiene los detalles técnicos de
 * cómo se almacenan y recuperan los datos.
 * 
 * Cómo interactúa con otros archivos:
 * - Es utilizado por ExpenseRepositoryImpl como dependencia
 * - Trabaja directamente con objetos Expense de la capa de dominio
 * - Implementa el almacenamiento en memoria (no persistente)
 * - No conoce nada sobre casos de uso ni presentación
 * 
 * Descripción del código:
 * Primero se define la interfaz abstracta ExpenseDataSource que establece el contrato
 * para cualquier fuente de datos de gastos, con métodos add, getAll, update y delete.
 * Luego, LocalExpenseDataSource implementa esta interfaz usando una lista en memoria
 * (_expenses) como almacenamiento temporal. El método add agrega gastos a la lista,
 * delete remueve elementos usando removeWhere con el ID, getAll retorna una copia de
 * la lista para evitar modificaciones externas directas, y update busca el índice del
 * gasto y lo reemplaza si existe.
 */

import 'package:expense_tracker_session/domain/entities/expense.dart';

/// Interfaz para el Data Source. Define el contrato para el manejo de datos.
abstract class ExpenseDataSource {
  /// Agrega un nuevo gasto a la fuente de datos
  Future<void> add(Expense expense);
  
  /// Obtiene todos los gastos de la fuente de datos
  Future<List<Expense>> getAll();
  
  /// Actualiza un gasto existente en la fuente de datos
  Future<void> update(Expense expense);
  
  /// Elimina un gasto de la fuente de datos por su ID
  Future<void> delete(String id);
}

/// Implementación del Data Source en memoria (sin persistencia).
/// 
/// Esta implementación usa una lista en memoria, por lo que los datos se pierden
/// al cerrar la aplicación. En producción se reemplazaría por SQLite, Hive,
/// SharedPreferences, o una API remota.
class LocalExpenseDataSource implements ExpenseDataSource {
  /// Lista que actúa como almacenamiento temporal en memoria.
  /// Los datos se pierden al cerrar la aplicación.
  final List<Expense> _expenses = [];

  /// Agrega un nuevo gasto a la lista en memoria
  /// 
  /// En un caso real, aquí se generaría el ID automáticamente si fuera necesario,
  /// pero en este caso asumimos que el ID se genera antes de llamar a este método.
  /// 
  /// Parámetros:
  /// - [expense]: El objeto Expense a agregar
  /// 
  /// Retorna: Future<void> que completa cuando se agrega el gasto
  @override
  Future<void> add(Expense expense) async {
    _expenses.add(expense);
  }

  /// Elimina un gasto de la lista en memoria por su ID
  /// 
  /// Usa removeWhere para eliminar el elemento que coincida con el ID proporcionado.
  /// 
  /// Parámetros:
  /// - [id]: El identificador único del gasto a eliminar
  /// 
  /// Retorna: Future<void> que completa cuando se elimina el gasto
  @override
  Future<void> delete(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
  }

  /// Obtiene todos los gastos de la lista en memoria
  /// 
  /// Retorna una copia de la lista para evitar modificaciones externas directas.
  /// Esto es una buena práctica para mantener la encapsulación de datos.
  /// 
  /// Retorna: Future<List<Expense>> con todos los gastos almacenados
  @override
  Future<List<Expense>> getAll() async {
    return List.from(_expenses);
  }

  /// Actualiza un gasto existente en la lista en memoria
  /// 
  /// Busca el gasto por su ID y lo reemplaza con la nueva versión.
  /// Si el gasto no existe, no hace nada (opcionalmente se podría lanzar una excepción).
  /// 
  /// Parámetros:
  /// - [updatedExpense]: El objeto Expense con los datos actualizados
  /// 
  /// Retorna: Future<void> que completa cuando se actualiza el gasto
  @override
  Future<void> update(Expense updatedExpense) async {
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
    }
    // Opcional: Podrías lanzar una excepción si el gasto no existe.
  }
}
/*
 * Archivo: expense.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Este archivo representa la ENTIDAD DE NEGOCIO fundamental del sistema.
 * En Clean Architecture, las entidades son los objetos que contienen las reglas
 * de negocio más críticas e independientes de cualquier framework o tecnología externa.
 * La clase Expense define la estructura básica de un gasto en el dominio del problema.
 * 
 * Cómo interactúa con otros archivos:
 * - Es utilizada por TODOS los demás archivos del proyecto como el modelo de datos central
 * - Los REPOSITORIOS (tanto el contrato como la implementación) trabajan con esta entidad
 * - Los CASOS DE USO reciben y retornan objetos de tipo Expense
 * - El PROVIDER manipula listas de Expense
 * - Las PANTALLAS muestran la información contenida en Expense
 * 
 * Descripción del código:
 * La clase Expense es inmutable (usando 'final' y 'const') y contiene cinco propiedades
 * esenciales que describen un gasto: un identificador único (id), una descripción textual
 * del gasto (description), el monto monetario (amount), la fecha en que ocurrió (date),
 * y una categoría que lo clasifica (category). El método copyWith proporciona una manera
 * funcional de crear copias modificadas del objeto sin mutar el original, lo cual es útil
 * para operaciones de actualización donde se necesita mantener la inmutabilidad del estado.
 */

/// Representa un gasto en el sistema.
/// Esta es la clase central (Entidad) de la lógica de negocio.
class Expense {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  const Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  /// Método copyWith - Crea una copia del objeto Expense con valores opcionales modificados
  /// 
  /// Este método permite crear una nueva instancia de Expense manteniendo algunos valores
  /// del objeto original y modificando otros. Es esencial para mantener la inmutabilidad.
  /// 
  /// Parámetros opcionales:
  /// - [id]: Nuevo identificador (si se proporciona)
  /// - [description]: Nueva descripción (si se proporciona)
  /// - [amount]: Nuevo monto (si se proporciona)
  /// - [date]: Nueva fecha (si se proporciona)
  /// - [category]: Nueva categoría (si se proporciona)
  /// 
  /// Retorna: Una nueva instancia de Expense con los valores actualizados
  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
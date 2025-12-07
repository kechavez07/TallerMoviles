import 'package:flutter/foundation.dart'; // Para @required, aunque ahora es más común usar 'required'

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

  // Método opcional para facilitar la copia de la entidad, 
  // útil para la función de editar (update)
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
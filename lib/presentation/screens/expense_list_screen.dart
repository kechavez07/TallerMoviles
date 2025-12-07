/*
 * Archivo: expense_list_screen.dart
 * 
 * Propósito dentro de Clean Architecture:
 * Es la PANTALLA PRINCIPAL de la aplicación que muestra la lista de gastos y el saldo total.
 * Pertenece a la capa de presentación y se enfoca exclusivamente en la construcción de
 * la interfaz de usuario.
 * 
 * Cómo interactúa con otros archivos:
 * - Consume el ExpenseProvider mediante context.watch<ExpenseProvider>()
 * - Navega hacia AddExpenseScreen cuando se presiona el botón de agregar
 * - Navega hacia EditExpenseScreen cuando se presiona el botón de editar
 * - Muestra objetos Expense en una lista
 * - Llama métodos del provider como deleteExpense
 * 
 * Descripción del código:
 * La clase ExpenseListScreen es un widget sin estado (StatelessWidget) que construye
 * la interfaz principal. Usa context.watch<ExpenseProvider>() para escuchar cambios en
 * el estado del provider y reconstruirse automáticamente. El Scaffold incluye un AppBar
 * con el título, y el body muestra un indicador de carga cuando isLoading es true.
 * Cuando los datos están cargados, muestra una columna con dos secciones: una tarjeta
 * que presenta el saldo total calculado y una lista scrolleable de gastos. Cada gasto
 * se representa con un ListTile que muestra la descripción, fecha formateada, categoría,
 * monto, un botón de editar y un botón de eliminar.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/presentation/providers/expense_provider.dart';
import 'package:expense_tracker_session/presentation/screens/add_expense_screen.dart';
import 'package:expense_tracker_session/presentation/screens/edit_expense_screen.dart';

/// Pantalla principal que muestra la lista de gastos
/// 
/// Esta es la pantalla de inicio de la aplicación.
class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  /// Construye la interfaz de usuario de la pantalla
  /// 
  /// Este método se ejecuta cada vez que el provider notifica cambios.
  /// 
  /// Parámetros:
  /// - [context]: El BuildContext que proporciona acceso al árbol de widgets
  /// 
  /// Retorna: El widget Scaffold que contiene toda la UI de la pantalla
  @override
  Widget build(BuildContext context) {
    // Escucha el provider para reconstruir automáticamente cuando hay cambios
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(' Registro y control de Gastos'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                // Saldo Total
                _buildTotalBalanceCard(provider.totalBalance),

                // Lista de Gastos
                Expanded(
                  child: provider.expenses.isEmpty
                      ? const Center(child: Text('No hay gastos registrados en esta sesión.'))
                      : ListView.builder(
                          itemCount: provider.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = provider.expenses[index];
                            return _buildExpenseTile(context, provider, expense);
                          },
                        ),
                ),
              ],
            ),
        // Botón flotante para agregar nuevos gastos
        floatingActionButton: Center(
          child: SizedBox(
            width: 180,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Añadir Gasto'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Navega a la pantalla de agregar gasto
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }

  // === MÉTODOS AUXILIARES PARA CONSTRUIR WIDGETS ===

  /// Construye la tarjeta que muestra el saldo total
  /// 
  /// Parámetros:
  /// - [balance]: El balance total calculado de todos los gastos
  /// 
  /// Retorna: Widget Card con el balance formateado
  Widget _buildTotalBalanceCard(double balance) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Total gastado:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            Text(
              '${NumberFormat.currency(symbol: '\$').format(balance)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un ListTile para mostrar un gasto individual
  /// 
  /// Parámetros:
  /// - [context]: El BuildContext para acceder al provider
  /// - [provider]: El ExpenseProvider para llamar al método deleteExpense
  /// - [expense]: El objeto Expense a mostrar
  /// 
  /// Retorna: Widget ListTile con la información del gasto
  Widget _buildExpenseTile(BuildContext context, ExpenseProvider provider, Expense expense) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(expense.category[0]),
      ),
      title: Text(expense.description),
      subtitle: Text(
        '${DateFormat('dd/MM/yyyy').format(expense.date)} - ${expense.category}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${NumberFormat.currency(symbol: '\$').format(expense.amount)}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          // Botón de editar gasto
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              // Navega a la pantalla de edición pasando el gasto a editar
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditExpenseScreen(expense: expense),
                ),
              );
            },
          ),
          // Botón de eliminar gasto
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // Llama al método del Provider que usa el Caso de Uso y el Repositorio
              provider.deleteExpense(expense.id);
            },
          ),
        ],
      ),
    );
  }
}
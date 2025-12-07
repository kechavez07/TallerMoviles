import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import 'package:expense_tracker_session/domain/entities/expense.dart';
import 'package:expense_tracker_session/presentation/providers/expense_provider.dart';
import 'package:expense_tracker_session/presentation/screens/add_expense_screen.dart'; // Creada en el paso 6.2

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha el provider para reconstruir cuando hay cambios
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

  // --- Widgets Auxiliares ---

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
          // Botón de eliminar
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: () {
              // Llamada al método del Provider que usa el Caso de Uso y el Repositorio
              provider.deleteExpense(expense.id);
            },
          ),
        ],
      ),
    );
  }
}